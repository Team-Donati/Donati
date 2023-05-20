import { ethers } from "hardhat";
import { Factory, Whitelist } from "../typechain-types";
import * as dotenv from "dotenv";
import { BigNumber } from "ethers";

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
    ethers.utils.parseEther("0.0001")
  );
}

async function deployContracts() {
  //deploy factory
  const Factory = await ethers.getContractFactory("Factory");
  const factory = await Factory.deploy();
  await factory.deployed();

  console.log("Facotory address", factory.address);

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
  minimumDonateValue: BigNumber
) {
  await (
    await factory.deploySet(
      recipientAddress,
      whitelist.address,
      recipientFisrtName,
      recipientLastName,
      minimumDonateValue
    )
  ).wait();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
