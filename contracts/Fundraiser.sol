// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

// TODO : whitelist claimer 
// TODO : shutdown 시 donate 비율 계산해서 돌려주기
// TODO : IERC721 아닌 donati NFT interface import

contract Fundraiser {
    IERC721 public NFT;

    address payable immutable recipient; // 수혜자
    uint public minimumDonate;

    address payable[] public claimers; // whitelist 누가 추가/삭제권한?
    address public reporter;

    address[] donators;
    mapping(address => uint) public donatorFundAmount; // donator - fundAmt
    mapping(address => uint) public donatorTokenId;

    uint private currentFundAmount; // 굳이 필요한가? 
    uint private claimCount;

    struct Claim {
        address claimer; 
        uint amount;
        uint time;
    }

    struct Donate {
        uint amount;
        uint time;
    }

    mapping(uint => Claim) public claimHistory; // claimCount-claimInfo
    mapping(address => Donate[]) public donateHistory; // donator - donateInfo[]
    
    
    constructor(address _tokenAddress, address _recipient, address _reporter, uint _minimumDonate) payable {
        NFT = IERC721(_tokenAddress);
        reporter = _reporter;
        recipient = payable(_recipient);
        claimers.push(recipient);
        minimumDonate = _minimumDonate;
    }

    modifier onlyReporter {
        require(msg.sender == reporter, "Fundraiser: Caller must be reporter");
        _;
    }

    modifier onlyClaimer {
        require(_isClaimer(msg.sender), "Fundraiser: Caller must be claimer");
        _;
    }

    function claim(uint amount) external onlyClaimer { // TODO : 멀티시그 구현 필요
        require(address(this).balance > amount , "Fundraiser: Overclaimed");
        
        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed.");

        Claim memory history = Claim(msg.sender, amount, block.timestamp);
        claimCount += 1;
        claimHistory[claimCount] = history;

        currentFundAmount -= amount;
    }

    function donate() external payable{
        require(msg.value > minimumDonate , "Fundraiser : Invalid value");
        if (!_hasToken(msg.sender)) {
            // NFT mint . 우리 NFT의 인터페이스 필요함
            // donatorTokenId 등록;
            donators.push(msg.sender);
        } 
        donatorFundAmount[msg.sender] += msg.value;
        currentFundAmount += msg.value;

        Donate memory history = Donate(msg.value, block.timestamp);
        donateHistory[msg.sender].push(history);
        
    }

    function setMinimumDonate(uint _minimumDonate) external onlyReporter {
        minimumDonate = _minimumDonate;
    } 

    function getDonatorLastDonatation(address donator) external view returns(Donate memory) {
        uint length = donateHistory[donator].length;
        return donateHistory[donator][length-1];
    }
    
    function getCurrentFundAmount() public view returns(uint) {
        return currentFundAmount;
    }

    function getDepositorFundAmount(address addr) public view returns(uint) {
        require(_hasToken(addr), "Fundraiser : Given address is not depositor");
        return donatorFundAmount[addr];
    }

    function getTokenId(address addr) public view returns(uint) {
        require(_hasToken(addr), "Fundraiser : given address is not depositor");
        return donatorTokenId[addr];
    }

    function isDepositor(address addr) public view returns(bool) {
        return _hasToken(addr);
    }

    function _hasToken(address addr) private view returns(bool) {
        return donatorTokenId[addr] > 0;
    }

    function _isClaimer(address addr) private view returns(bool) {
        for (uint i = 0; i < claimers.length; i++) {
            if (addr == claimers[i]) {
                return true;
            }
        }
        return false;
    }

}