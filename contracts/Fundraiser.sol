// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "./interfaces/IWhitelist.sol";

// TODO : IERC721 아닌 donati NFT interface import

contract Fundraiser {

    struct Recipient { 
        address recipientAddress;
        string name;
    }

    struct Claim {
        address claimer; 
        address paymentDst; // 거래처(whitelist addr)
        uint amount;
        uint time;
    }

    struct Donate {
        uint amount;
        uint time;
    }

    IERC721 public NFT;
    IWhitelist whitelist;
    Recipient private recipient;

    uint public minimumDonate;

    address payable[] public claimers;
    address public reporter;

    address[] donators;
    mapping(address => uint) public donatorFundAmount; // donator - fundAmt
    mapping(address => uint) public donatorTokenId;

    uint private currentFundAmount;
    uint private claimCount;

    mapping(uint => Claim) public claimHistory; // claimCount-claimInfo
    mapping(address => Donate[]) public donateHistory; // donator - donateInfo[]
    
    
    constructor(address _tokenAddress, address _recipient, address _whitelist, string memory _recipientName, address _reporter, uint _minimumDonate) payable {
        NFT = IERC721(_tokenAddress);
        whitelist = IWhitelist(_whitelist);
        reporter = _reporter;
        recipient = Recipient(payable(_recipient), _recipientName);
        minimumDonate = _minimumDonate;
    }

    modifier onlyReporter {
        require(msg.sender == reporter, "Fundraiser: Caller must be reporter");
        _;
    }

    modifier onlyWhitelist(address _addr) {
        bool isWhitelist = whitelist.isWhitelist(_addr);
        require(whitelist.isWhitelist(_addr), "Fundraiser: Address is not on whitelist");
        _;
    }

    function claim(uint _amount, address _whitelistAddr) external onlyWhitelist(_whitelistAddr) {
        require(address(this).balance > _amount , "Fundraiser: Overclaimed");
        
        (bool success, ) = payable(_whitelistAddr).call{value: _amount}("");
        require(success, "Transfer failed.");

        Claim memory history = Claim(msg.sender, _whitelistAddr, _amount, block.timestamp);
        claimCount += 1;
        claimHistory[claimCount] = history;

        currentFundAmount -= _amount;
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