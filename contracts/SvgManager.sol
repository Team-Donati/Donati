// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/math/Math.sol";
import "base64-sol/base64.sol";

library SvgManager {
    using Math for uint256;

    function makeSvgUri(
        uint256 letterType, 
        bytes32[5] storage contents, 
        string storage ownerName
    ) internal view returns(string memory) {
        string memory nftImage = Base64.encode(bytes(makeSvg(letterType, contents, ownerName)));

        return string(abi.encodePacked(
            'data:image/svg+xml;base64,',
            nftImage
        ));
    }

    function makeSvg(
        uint256 letterType, 
        bytes32[5] storage contents, 
        string storage ownerName
    ) internal view returns(string memory) {
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

    function _makeName(uint256 letterType, string storage ownerName) internal pure returns(string memory) {
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
                '<text transform="translate(65.26 441.35)" style="fill: ',
                color,
                '; font-family: Poppins-SemiBold, Poppins; font-size: 41px; font-weight: 600; letter-spacing: -.04em;"><tspan x="0" y="-18">',
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
                '<text transform="translate(283.25 401.89)" style="fill: ', color1, '; font-family: Poppins-Regular, Poppins; font-size: 14px;"><tspan x="-14" y="-18">FROM</tspan></text>',
                '<line x1="32.71" y1="82.78" x2="200.88" y2="82.78" style="fill: none; stroke: ', color2, '; stroke-miterlimit: 10;"/>', // 밑줄 색
                '<line x1="32.71" y1="146.83" x2="310.87" y2="146.83" style="fill: none; stroke: ', color2, '; stroke-miterlimit: 10;"/>', // 밑줄 색
                '<line x1="32.71" y1="190.88" x2="310.87" y2="190.88" style="fill: none; stroke: ', color2, '; stroke-miterlimit: 10;"/>', // 밑줄 색
                '<line x1="32.71" y1="234.92" x2="310.87" y2="234.92" style="fill: none; stroke: ', color2, '; stroke-miterlimit: 10;"/>', // 밑줄 색
                '<line x1="32.71" y1="278.97" x2="310.87" y2="278.97" style="fill: none; stroke: ', color2, '; stroke-miterlimit: 10;"/>', // 밑줄 색
                '<line x1="32.71" y1="323.01" x2="310.87" y2="323.01" style="fill: none; stroke: ', color2, '; stroke-miterlimit: 10;"/>' // 밑줄 색
            )
        );
    }

    function _makeContents(uint256 letterType, bytes32[5] storage contents) internal view returns(string memory) {
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

        return string(
            abi.encodePacked(
                '<text transform="translate(24.4 73.66)" style="fill: #24262b; font-family: SFProDisplay-Regular, &apos;SF Pro Display&apos;; font-size: 18px;">',
                '<tspan x="15" y="0">Dear, My friend.</tspan>',
                '<tspan x="15" y="64" style="letter-spacing: .02em; fill: ', color, ';">', string(abi.encodePacked(contents[0])),'</tspan>',
                '<tspan x="15" y="108" style="letter-spacing: .02em; fill: ', color, ';">', string(abi.encodePacked(contents[1])) ,'</tspan>',
                '<tspan x="15" y="152" style="letter-spacing: .02em; fill: ', color, ';">', string(abi.encodePacked(contents[2])), '</tspan>',
                '<tspan x="15" y="196" style="letter-spacing: .02em; fill: ', color, ';">', string(abi.encodePacked(contents[3])), '</tspan>',
                '<<tspan x="15" y="240" style="letter-spacing: .02em; fill: ', color, ';">', string(abi.encodePacked(contents[4])), '</tspan>',
                '</text>'
            )
        );
    }
}