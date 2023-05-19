// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Fundraiser.sol";

contract Factory{

    struct FundraiseSet {
        Fundraiser fundraiser;
        //DonaFT donaFT;
    }

    mapping (address => FundraiseSet) private RecipientFundraiseSet;
    address[] private fundraisers;
    address[] private nfts;
    

    function deploySet (
        address _recipient, 
        address _whitelistContract, 
        bytes32 _recipientName, 
        uint _minimumDonate) external {
            // deploy contract address
            Fundraiser fundraiser = new Fundraiser (
                address(donaFT),
                _recipient, 
                _whitelistContract,
                _recipientName,
                msg.sender,
                _minimumDonate
                );
            fundraisers.push(address(fundraiser));
            nfts.push(address(donaFT));
            FundraiseSet newSet = new FundraiseSet(fundraiser, donaFT);
            RecipientFundraiseSet[_recipient]= newSet;
            
    }
    
    function getAllNfts() public view returns(address[] memory) {
        return nfts;
    }

    function getAllFundraisers() public view returns(address[] memory) {
        return fundraisers;
    }

    function getFundraiseSet(address _recipient) public view returns(FundraiseSet memory) {
        return RecipientFundraiseSet[_recipient];
    }
    
}