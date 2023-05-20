// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interfaces/IDonaFT.sol";
import "./interfaces/IWhitelist.sol";
import "@opengsn/contracts/src/ERC2771Recipient.sol";

contract Fundraiser is ERC2771Recipient {

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
    
    event Claimed(address indexed claimer, address indexed paymentDst, uint amount, uint indexed time);
    event Donated(address indexed donator, uint amount, uint indexed time);

    constructor(address _tokenAddress, address _recipient, address _whitelist, string memory _recipientName, address _reporter, uint _minimumDonate, address _forwarder) payable {
        NFT = IDonaFT(_tokenAddress);
        whitelist = IWhitelist(_whitelist);
        reporter = _reporter;
        recipient = Recipient(payable(_recipient), _recipientName);
        minimumDonate = _minimumDonate;
        _setTrustedForwarder(_forwarder);
    }

    modifier onlyReporter {
        require(_msgSender() == reporter, "Fundraiser: Caller must be reporter");
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

        Claim memory history = Claim(_msgSender(), _whitelistAddr, _amount, block.timestamp);
        claimCount += 1;
        claimHistory[claimCount] = history;

        currentFundAmount -= _amount;

        emit Claimed(_msgSender(), _whitelistAddr, _amount, block.timestamp);
    }

    function donate() external payable{
        require(msg.value > minimumDonate , "Fundraiser : Invalid value");
        if (!_hasToken(_msgSender())) {
            uint tokenId = NFT.mint(_msgSender());
            donatorTokenId[_msgSender()] = tokenId;
            donators.push(_msgSender());
        } 
        donatorFundAmount[_msgSender()] += msg.value;
        currentFundAmount += msg.value;

        Donate memory history = Donate(msg.value, block.timestamp);
        donateHistory[_msgSender()].push(history);
        
        emit Donated(_msgSender(), msg.value, block.timestamp);
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