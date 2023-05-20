// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/math/Math.sol";
import "base64-sol/base64.sol";

library SvgManager {
    using Math for uint256;

    function makeSvgUri(
        uint256 letterType, 
        string calldata contents, 
        string calldata ownerName
    ) internal pure returns(string memory) {
        string memory nftImage = Base64.encode(bytes(makeSvg(letterType, contents, ownerName)));

        return string(abi.encodePacked(
            'data:image/svg+xml;base64,',
            nftImage
        ));
    }
    
    function makeSvg(
        uint256 letterType, 
        string calldata contents, 
        string calldata ownerName
    ) internal pure returns(string memory) {
        string memory color = '#FFFFFF';

        if(letterType == 1){
            color = '#1E262D';
        }
        else if(letterType == 2){
            color = '#F6FDDB';
        }
        else if(letterType == 3){
            color = '#E2B6BF';
        }

        return string(
            abi.encodePacked(
                '<?xml version="1.0" encoding="UTF-8"?>',
                '<svg id="Layer_2" data-name="Layer 2" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 345 465.66">',
                '<g id="Layer_1-2" data-name="Layer 1">',
                '<g>',
                '<rect width="345" height="465" rx="17" ry="17" style="fill: ', color, ';"/>', // fill => 편지 바탕 색      
                _makeName(letterType, ownerName),
                _makeFormat(letterType),
                _makeContents(letterType, contents),
                '</g>',
                '</g>',
                '</svg>'
            )
        );

    }

    function _makeName(uint256 letterType, string calldata ownerName) internal pure returns(string memory) {
        string memory color = '#24262B'; // 이름 색

        if(letterType == 1){
            color = '#F7FEDC';
        }
        else if(letterType == 2){
            color = '#2F3A39';
        }
        else if(letterType == 3){
            color = '#5C2E2D';
        }

        return string(
            abi.encodePacked(
                '<text transform="translate(65.26 441.35)" style="fill: ', color,'; font-family: Poppins-SemiBold, Poppins; font-size: 41px; font-weight: 600; letter-spacing: -.04em;"><tspan x="0" y="0">', 
                ownerName, 
                '</tspan></text>'
            )
        );
    }

    function _makeFormat(uint256 letterType) internal pure returns(string memory) {
        string memory color1 = '#E5AAD3'; // from 색
        string memory color2 = '#DD9ECD'; // 밑줄 색

        if(letterType == 1){
            color1 = '#5AB7AC';
            color2 = '#337770';
        }
        else if(letterType == 2){
            color1 = '#B4D864';
            color2 = '#B4D864';
        }
        else if(letterType == 3){
            color1 = '#FFFFFF';
            color2 = '#FFFFFF';
        }

        return string(
            abi.encodePacked(
                '<text transform="translate(283.25 401.89)" style="fill: ', color1, '; font-family: Poppins-Regular, Poppins; font-size: 14px;"><tspan x="0" y="0">FROM</tspan></text>', // from 색
                '<line x1="21.71" y1="82.78" x2="207.88" y2="82.78" style="fill: none; stroke: ', color2, '; stroke-miterlimit: 10;"/>', // 밑줄 색
                '<line x1="21.71" y1="126.83" x2="321.87" y2="126.83" style="fill: none; stroke: ', color2, '; stroke-miterlimit: 10;"/>', // 밑줄 색
                '<line x1="21.71" y1="170.88" x2="321.87" y2="170.88" style="fill: none; stroke: ', color2, '; stroke-miterlimit: 10;"/>', // 밑줄 색
                '<line x1="21.71" y1="214.92" x2="321.87" y2="214.92" style="fill: none; stroke: ', color2, '; stroke-miterlimit: 10;"/>', // 밑줄 색
                '<line x1="21.71" y1="258.97" x2="321.87" y2="258.97" style="fill: none; stroke: ', color2, '; stroke-miterlimit: 10;"/>', // 밑줄 색
                '<line x1="21.71" y1="303.01" x2="321.87" y2="303.01" style="fill: none; stroke: ', color2, '; stroke-miterlimit: 10;"/>', // 밑줄 색
                '<line x1="21.71" y1="347.06" x2="321.87" y2="347.06" style="fill: none; stroke: ', color2, '; stroke-miterlimit: 10;"/>' // 밑줄 색
            )
        );
    }

    function _makeContents(uint256 letterType, string calldata contents) internal pure returns(string memory) {
        string memory color = '#24262B'; // contents 색

        if(letterType == 1){
            color = '#F7FEDC';
        }
        else if(letterType == 2){
            color = '#2F3A39';
        }
        else if(letterType == 3){
            color = '#5C2E2D';
        }

        uint256 lineCnt = (bytes(contents).length).ceilDiv(35);
        string[6] memory lines; // 최대 6줄까지 가능

        for (uint i=0; i<6; i++){ // 0 - 5
            if(lineCnt < i) {
                lines[i] = "";
                continue;
            }
            uint start = i*36;
            uint end = Math.min(bytes(contents).length, (i+1)*36);
            lines[i] = contents[start:end];
        }

        return string(
            abi.encodePacked(
                '<text transform="translate(22.4 73.66)" style="fill: ', color, '; font-family: SFProDisplay-Regular, &apos;SF Pro Display&apos;; font-size: 18px;">',
                'Dear, My friend.',
                '<tspan x="0" y="44" style="letter-spacing: .02em; fill: ', color, ';">', lines[0],'</tspan>',
                '<tspan x="0" y="88" style="letter-spacing: .02em; fill: ', color, ';">', lines[1] ,'</tspan>',
                '<tspan x="0" y="132" style="letter-spacing: .02em; fill: ', color, ';">', lines[2], '</tspan>',
                '<tspan x="0" y="176" style="letter-spacing: .02em; fill: ', color, ';">', lines[3], '</tspan>',
                '<tspan x="0" y="220" style="letter-spacing: .02em; fill: ', color, ';">', lines[4], '</tspan>',
                '<tspan x="0" y="264" style="letter-spacing: .02em; fill: ', color, ';">', lines[5], '</tspan>',
                '</text>'
            )
        );
    }
}