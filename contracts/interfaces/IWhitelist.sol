// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IWhitelist {

    function getWhitelist() external view returns(address[] memory);

    function addToWhitelist( address[] memory addresses) external;

    function removeFromWhitelist( address[] memory addresses) external;

    function isWhitelist( address addr) external view returns(bool);

    event WhitelistAdded( address[] addedWhitelist, uint addedLength);
    event WhitelistRemoved( address[] removedWhitelist, uint removedLength);

}