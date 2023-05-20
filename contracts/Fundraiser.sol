// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interfaces/IDonaFT.sol";
import "./interfaces/IWhitelist.sol";

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

    IDonaFT public NFT;
    IWhitelist whitelist;
    Recipient private recipient;

    uint public minimumDonate;

    address public reporter;

    address[] donators;
    mapping(address => uint) private donatorFundAmount; // donator - fundAmt
    mapping(address => uint) private donatorTokenId;

    uint private currentFundAmount;
    uint private claimCount;

    mapping(uint => Claim) private claimHistory; // claimCount-claimInfo
    mapping(address => Donate[]) private donateHistory; // donator - donateInfo[]
    
    
    constructor(address _tokenAddress, address _recipient, address _whitelist, string memory _recipientName, address _reporter, uint _minimumDonate) payable {
        NFT = IDonaFT(_tokenAddress);
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
            uint tokenId = NFT.mint(msg.sender);
            donatorTokenId[msg.sender] = tokenId;
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

}