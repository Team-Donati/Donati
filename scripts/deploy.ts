import { ethers } from "hardhat";
import { Factory, Whitelist } from "../typechain-types";
import * as dotenv from "dotenv";
import { BigNumber } from "ethers";
import fundraiserAbi from "../artifacts/contracts/Fundraiser.sol/Fundraiser.json";
import nftAbi from "../artifacts/contracts/DonaFT.sol/DonaFT.json";

dotenv.config();

async function main() {
  const { whitelist, factory } = await deployContracts();

  // deploy Set 1
  await deployFundraiseSet(
    whitelist,
    factory,
    process.env.TEST_RECIPIENT1 || "",
    process.env.RECIPIENT1_FISRTNAME || "",
    process.env.RECIPIENT1_LASTNAME || "",
    ethers.utils.parseEther("0.0001"),
    process.env.TRUSTED_FORWARDER_CONTRACT_ADDRESS || "0x52C84043CD9c865236f11d9Fc9F56aa003c1f922"
  );

  // deploy Set 2
  await deployFundraiseSet(
    whitelist,
    factory,
    process.env.TEST_RECIPIENT2 || "",
    "Gildong",
    "Hong",
    ethers.utils.parseEther("0.0001")
  );
  
  const fundraisers = await factory.getAllFundraisers()
  const nfts = await factory.getAllNfts()
  console.log(fundraisers);
  console.log(nfts);

  const deployer = await ethers.getSigners();

  // donate1
  const fundraiser1 = new ethers.Contract(fundraisers[0], fundraiserAbi.abi, deployer[0]);
  await fundraiser1.connect(deployer[1]).donate({value: ethers.utils.parseEther("0.1")});

  // donate2
  const fundraiser2 = new ethers.Contract(fundraisers[1], fundraiserAbi.abi, deployer[0]);
  await fundraiser2.connect(deployer[1]).donate({value: ethers.utils.parseEther("0.1")});

  console.log(deployer[0].address, deployer[1].address)
}

async function deployContracts() {
  //deploy factory
  const Factory = await ethers.getContractFactory("Factory");
  const factory = await Factory.deploy();
  await factory.deployed();

  console.log("Factory address", factory.address);

  //deploy whitelist
  const Whitelist = await ethers.getContractFactory("Whitelist");
  const whitelist = await Whitelist.deploy();
  await whitelist.deployed();

  console.log("Whitelist address", whitelist.address);

  return { whitelist, factory };
}

async function deployFundraiseSet(
  whitelist: Whitelist,
  factory: Factory,
  recipientAddress: string,
  recipientFisrtName: string,
  recipientLastName: string,
  minimumDonateValue: BigNumber,
  trustedForwarderAddress: string
) {
  await (
    await factory.deploySet(
      recipientAddress,
      whitelist.address,
      recipientFisrtName,
      recipientLastName,
      minimumDonateValue,
      trustedForwarderAddress
    )
  ).wait();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
