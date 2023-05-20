// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IDonaFT {
    function mint(address ownerAddr) external returns(uint256 tokenId);
    function tokenURI(uint256 tokenId) external view returns (string memory);
    function letterURI(uint256 letterType, uint256 letterId) external view returns (string memory);
    function updateLetter(bytes32[5] calldata contents) external;
}