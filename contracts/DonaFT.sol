// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721URIStorage.sol
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "base64-sol/base64.sol";
import "./SvgManager.sol";

import "hardhat/console.sol";

contract DonaFT is ERC721 {
    using Strings for uint256;
    using Counters for Counters.Counter;

    //Factory
    address private _factory;
    
    // 편지 history
    mapping(uint256 => bytes32[5]) private _letters;
    Counters.Counter private _letterCnt;

    // token Id 
    Counters.Counter private _tokenId;

    struct Writer {
        address writerAddr;
        string writerName;
    }

    Writer public writer;
    address private _fundraiser;

    modifier onlyWriter() {
        require(msg.sender == writer.writerAddr, "Only writer");
        _;
    }

    modifier onlyFundraiser() {
        require(msg.sender == _fundraiser, "Only fundraiser");
        _;
    }

    modifier onlyFactory() {
        require(msg.sender == _factory, "Only factory"); 
        _;
    }

    constructor(address factoryAddr_ , string memory firstName_, string memory lastName_, address writerAddr_) 
    ERC721(string(abi.encodePacked("Letter from ", firstName_)), lastName_) { // symbol_은 유저 name의 축어
        writer = Writer(writerAddr_, string(abi.encodePacked(firstName_, " ", lastName_)));
        _factory = factoryAddr_;
        _letters[0] = [bytes32(""), bytes32(""), bytes32(""), bytes32(""), bytes32("")];
        _letterCnt.increment();
    }

    function setFundraiser(address fundraiser_) external {
        require(fundraiser_ == address(0), "Already set");
        _fundraiser = fundraiser_;
    }

    function updateLetter(bytes32[5] calldata contents) external onlyWriter {
        // history에 letters 추가
        _letters[_letterCnt.current()] = contents;
        _letterCnt.increment();
    }

    // tokenId 반환
    function mint(address ownerAddr) public returns(uint256 tokenId) { //Todo internal, onlyFundraiser 추가하기
        require(_balances[ownerAddr] == 0, "Already minted");
        tokenId = _tokenId.current();
        _mint(ownerAddr, tokenId);
        _tokenId.increment();
    }

    // 항상 모든 토큰이 같은 이미지 출력
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        _requireMinted(tokenId);
        return SvgManager.makeSvg(0, _letters[_letterCnt.current()-1], writer.writerName);
    }

    function letterURI(uint256 letterType, uint256 letterId) public view returns (string memory) {
        require(letterId < _letterCnt.current(), "Doesnt exist");
        letterType = letterType % 4; // 편지 타입은 4개뿐
        return SvgManager.makeSvg(letterType, _letters[letterId], writer.writerName);
    }
}