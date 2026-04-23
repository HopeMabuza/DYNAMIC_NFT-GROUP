const { ethers, upgrades } = require("hardhat");

async function main() {
    const [owner, user1, user2] = await ethers.getSigners();


    const NFT = await ethers.getContractFactory("dNFT");
    const bURI = "ipfs://QmExampleHash/";
    const mintPrice = ethers.parseEther("0.0001");
    const nft = await upgrades.deployProxy(NFT, [20, mintPrice, bURI], { kind: "uups" });
    await nft.waitForDeployment();
    const nftAddress = await nft.getAddress();
    console.log("NFT deployed to:", nftAddress);
    console.log("Contract balance:", ethers.formatEther(await ethers.provider.getBalance(nftAddress)), "ETH");


    console.log("Successful Minting......");
    await nft.connect(owner).ownerMint();
    console.log("Owner minted, balance:", (await nft.balanceOf(owner.address)).toString());
    console.log("Contract balance:", ethers.formatEther(await ethers.provider.getBalance(nftAddress)), "ETH");


    await nft.connect(user1).mint({ value: mintPrice });
    console.log("User1 minted, balance:", (await nft.balanceOf(user1.address)).toString());
    console.log("Contract balance:", ethers.formatEther(await ethers.provider.getBalance(nftAddress)), "ETH");


    await nft.connect(user2).mint({ value: mintPrice });
    console.log("User2 minted, balance:", (await nft.balanceOf(user2.address)).toString());
    console.log("Contract balance:", ethers.formatEther(await ethers.provider.getBalance(nftAddress)), "ETH");

    console.log("Total supply:", (await nft.totalSupply()).toString());

    console.log("Double Mint Prevention.........");
    await nft.connect(owner).ownerMint().catch(e => console.log("Owner blocked:", e.message));
    await nft.connect(user1).mint({ value: mintPrice }).catch(e => console.log("User1 blocked:", e.message));
    await nft.connect(user2).mint({ value: mintPrice }).catch(e => console.log("User2 blocked:", e.message));

    
   console.log("Token URIs.....");

    const nftAsUser1 = nft.connect(user1);
    console.log("User1 tokenURI before threshold points:", await nftAsUser1.tokenURI(1));

    console.log("Incrementing user1 points for URI update");
    await nft.connect(owner).updatePoints(1, 11);

    console.log("User1 tokenURI after threshold points:", await nftAsUser1.tokenURI(1));


    console.log("Contract balance:", ethers.formatEther(await ethers.provider.getBalance(nftAddress)), "ETH");
    await nft.connect(owner).withdraw();

    console.log("Contract balance after withdraw:", ethers.formatEther(await ethers.provider.getBalance(nftAddress)), "ETH");
}

main().catch(console.error);
