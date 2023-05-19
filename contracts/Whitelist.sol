// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IWhitelist.sol";

contract Whitelist is Ownable, IWhitelist{
    
    address[] private _whitelist;
    mapping(address => uint) private _whitelistIndex;

    constructor() {
        _whitelist.push(address(0));
    }

    function isWhitelist(address addr) external view returns(bool) {
        return _isWhitelist(addr);
    }

    function _isWhitelist(address addr) private  view returns(bool){
       return _whitelistIndex[addr] > 0;
    }


    function addToWhitelist(address[] memory addresses) external onlyOwner {
    
        address[] memory addedAddress = new address[](addresses.length);
        uint idx = 0;
        for (uint i =0; i< addresses.length; i++) {
            if (addresses[i] == address(0) || _isWhitelist(addresses[i])) {
                continue;
            } 
            addedAddress[idx] = addresses[i];
            _whitelist.push(addresses[i]);
            _whitelistIndex[addresses[i]] = _whitelist.length - 1;
            unchecked{idx += 1;}
        } 
        emit WhitelistAdded(addedAddress, idx);
    }

    function removeFromWhitelist(address[] memory addresses) external onlyOwner {
        address[] memory removedAddress = new address[](addresses.length);
        uint removedAddressIdx = 0;

        for (uint i =0; i < addresses.length; i++) {
            if (addresses[i] == address(0) || !_isWhitelist(addresses[i])) {
                continue;
            } 
            uint idx = _whitelistIndex[addresses[i]];
            uint lastIdx = _whitelist.length - 1;
            
            if(lastIdx != idx) {
                address lastAddr = _whitelist[lastIdx];
                _whitelist[idx] = lastAddr;
                _whitelistIndex[lastAddr] = idx;
            }

            _whitelist.pop();
            delete _whitelistIndex[addresses[i]];

            removedAddress[removedAddressIdx] = addresses[i];
            unchecked{removedAddressIdx += 1;}

        } 
        emit WhitelistRemoved(removedAddress, removedAddressIdx);
    }

    function getWhitelist() external view returns(address[] memory){
        address[] memory whitelist = _whitelist;
        address[] memory slicedWhitelist = _sliceFirstElement(whitelist);

        return slicedWhitelist;
    }

}

function _sliceFirstElement(address[] memory arr) pure returns(address[] memory) {
    address[] memory slicedList = new address[](arr.length - 1);
    for(uint i = 1; i < arr.length; i++) {
        slicedList[i-1] = arr[i]; 
    }
    return slicedList;
}

