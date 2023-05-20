import { ethers } from "hardhat";

describe("DonaFT", () => {
    it("print nft", async () => {
        // 토큰 배포
        // message update
        console.log("ming");
        const [owner, otherAccount] = await ethers.getSigners();
        console.log(owner, otherAccount);

        const DonaFT = await ethers.getContractFactory("DonaFT");
        const donaFT = await DonaFT.deploy("Mingyun", "Seo", owner.address);

        // 하나 mint
        await donaFT.mint(otherAccount.address);
        
        // 편지 update
        await donaFT.updateLetter([
            ethers.utils.formatBytes32String("hi"), 
            ethers.utils.formatBytes32String("i'm"), 
            ethers.utils.formatBytes32String("mingyun"), 
            ethers.utils.formatBytes32String("thanks a lot"), 
            ethers.utils.formatBytes32String("i love you")
        ]);

        await donaFT.updateLetter([
            ethers.utils.formatBytes32String("hi!!!!"), 
            ethers.utils.formatBytes32String("i'm!!!!"), 
            ethers.utils.formatBytes32String("mingyun!!!!"), 
            ethers.utils.formatBytes32String("thanks a lot!!!!"), 
            ethers.utils.formatBytes32String("i love you!!!!!")
        ]);

        await donaFT.updateLetter([
            ethers.utils.formatBytes32String("hi????"), 
            ethers.utils.formatBytes32String("i'm????"), 
            ethers.utils.formatBytes32String("mingyun????"), 
            ethers.utils.formatBytes32String("thanks a lot????"), 
            ethers.utils.formatBytes32String("i love you????")
        ]);

        // nft 확인
        console.log(await donaFT.tokenURI(0));
        console.log("\n");
        console.log(await donaFT.letterURI(1, 1));
        console.log("\n");
        console.log(await donaFT.letterURI(2, 1));
        console.log("\n");
        console.log(await donaFT.letterURI(3, 1));

    })
})