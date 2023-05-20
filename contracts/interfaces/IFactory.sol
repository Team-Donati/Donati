// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IFactory {
    function getAllNfts() external view returns(address[] memory);
    function getAllFundraisers() external view returns(address[] memory);
}