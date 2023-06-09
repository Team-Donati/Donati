// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Fundraiser.sol";
import "./DonaFT.sol";

contract Factory{

    struct FundraiseSet {
        Fundraiser fundraiser;
        DonaFT donaFT;
    }

    mapping (address => FundraiseSet) private RecipientFundraiseSet;
    address[] private fundraisers;
    address[] private nfts;

    function deploySet (
        address _recipient, 
        address _whitelistContract, 
        string  calldata  _recipientFirstName,
        string calldata _recipientLastName, 
        uint _minimumDonate,
        address _forwarder
        ) external {
            
            DonaFT donaFT = new DonaFT (address(this), _recipientFirstName, _recipientLastName, _recipient);
            
            Fundraiser fundraiser = new Fundraiser (
                address(donaFT),
                _recipient, 
                _whitelistContract,
                string.concat(_recipientFirstName, _recipientLastName),
                msg.sender,
                _minimumDonate,
                _forwarder
                );
            donaFT.setFundraiser(address(fundraiser));

            fundraisers.push(address(fundraiser));
            nfts.push(address(donaFT));
            
            FundraiseSet memory newSet = FundraiseSet(fundraiser, donaFT);
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