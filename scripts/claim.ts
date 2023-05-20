const { ethers, waffle } = require("hardhat");
import { Factory, Whitelist } from "../typechain-types";
import * as dotenv from "dotenv";
import { BigNumber } from "ethers";
import fundraiserAbi from "../artifacts/contracts/Fundraiser.sol/Fundraiser.json";
import whitelistAbi from "../artifacts/contracts/Whitelist.sol/Whitelist.json";
import nftAbi from "../artifacts/contracts/DonaFT.sol/DonaFT.json";
import factoryAbi from "../artifacts/contracts/Factory.sol/Factory.json";

dotenv.config();

async function main() {
    const deployer = await ethers.getSigners();

    const factory = new ethers.Contract("0x5FbDB2315678afecb367f032d93F642f64180aa3", factoryAbi.abi, deployer[0]);
    console.log(await factory.getAllNfts());

    // // // white list에 추가하기
    // // const whitelist = new ethers.Contract("0x4A13aD9E5292916784E6CE6925ac2866464c5430", whitelistAbi.abi, deployer[0]);
    // // await whitelist.addToWhitelist([deployer[0].address, deployer[1].address]);

    // // // // claim 진행하기
    // // const fundraiser = new ethers.Contract("0xd25a84FaA6A0E523fB080fac8657F96D184b14B8", fundraiserAbi.abi, deployer[0]);
    // // await fundraiser.connect(deployer[0]).claim(ethers.utils.parseEther("0.03"), deployer[0].address);
    // // console.log("claim end");

    // const donaft1 = new ethers.Contract("0x0810dFdA6Fda0fB134Aec28E2F12Dc99d5477901", nftAbi.abi, deployer[0]);

    // await donaft1.connect(deployer[2]).updateLetter([
    //     convertStringToBytes32("hi"), 
    //     convertStringToBytes32("i am"), 
    //     convertStringToBytes32("ava ava ava ava"), 
    //     convertStringToBytes32("thanks a lot ovo"), 
    //     convertStringToBytes32("have a good time")
    // ]);

    // // const donaft2 = new ethers.Contract("0xd0DEE6d669eD82C6Fe2A4776239cCA9F92652A4B", nftAbi.abi, deployer[0]);
    // // await donaft2.connect(deployer[3]).updateLetter([
    // //     ethers.utils.formatBytes32String("hi                             "), 
    // //     ethers.utils.formatBytes32String("i am                           "), 
    // //     ethers.utils.formatBytes32String("gil dong gil dong              "), 
    // //     ethers.utils.formatBytes32String("thanks a lot ovo               "), 
    // //     ethers.utils.formatBytes32String("have a good time               ")
    // // ]);
}

function convertStringToBytes32(str: string) {
  const strBytes = ethers.utils.toUtf8Bytes(str);
  const bytes32Value = ethers.utils.arrayify(strBytes).slice(0, 32);

  return bytes32Value;
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  
