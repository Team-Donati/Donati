import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("DonaFT", function () {
    it("print nft", async() => {
        // 토큰 배포
        // message update

        const [owner, otherAccount] = await ethers.getSigners();

        const DonaFT = await ethers.getContractFactory("DonaFT");
        const donaFT = await DonaFT.deploy("Mingyun", "Seo", owner.address);

        // 하나 mint
        await donaFT.mint(otherAccount.address);
        
        // nft 확인
        string nftUri = await donaFT.tokenURI();
    })
}