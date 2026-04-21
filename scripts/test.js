const { ethers} = require("hardhat");
const { parseEther } = require("viem");

async function main(){
    const[owner, user1, user2, user3] = await ethers.getSigners();

    console.log("Deploying contract....");
    const NFT = await ethers.getContractFactory("dNFT");
    const mintPrice = ethers.parseEther("0.0001"); 
    const nft = await NFT.deploy(20, mintPrice);
    await nft.waitForDeployment();
    const nftAddress = await nft.getAddress();
    console.log("NFT deployed to:", nftAddress);

    console.log("Checking contract state...");
    console.log("Max Supply: ", (await nft.maxSupply()).toString());
    console.log("Total Supply: ", (await nft.totalSupply()).toString());
    console.log("Contract Balance: ", (await ethers.provider.getBalance(nftAddress)).toString());


    console.log("Minting NFTs...");
    await nft.connect(owner).ownerMint();
    console.log("Owner owns: ", (await nft.balanceOf(owner.address)).toString());
    console.log("Total Supply increased to ", (await nft.totalSupply()).toString());
    console.log("Contract Balance: ", (await ethers.provider.getBalance(nftAddress)).toString());

    
    await nft.connect(user1).mint({ value: mintPrice });
    console.log("User1 owns: ", (await nft.balanceOf(user1.address)).toString());
    console.log("Total Supply increased to ", (await nft.totalSupply()).toString());
    console.log("Contract Balance: ", (await ethers.provider.getBalance(nftAddress)).toString());

    await nft.connect(user2).mint({ value: mintPrice });
    console.log("User2 owns: ", (await nft.balanceOf(user2.address)).toString());
    console.log("Total Supply increased to ", (await nft.totalSupply()).toString());
    console.log("Contract Balance: ", (await ethers.provider.getBalance(nftAddress)).toString());

    console.log("Onwer tries to mint twice....");
    await nft.connect(owner).ownerMint().catch(e => console.log("Expected revert:", e.message));

    console.log("User1 tries to mint twice....");
    await nft.connect(user1).mint({ value: mintPrice }).catch(e => console.log("Expected revert:", e.message));

    console.log("User2 tries to transfer their NFT.....");
    const user2TokenId = 2; 
    await nft.connect(user2).transferFrom(user2.address, user3.address, user2TokenId).catch(e => console.log("Expected revert:", e.message));

    console.log("Onwer withdraws money....");
    await nft.connect(owner).withdraw();

    console.log("Contract Balance: ", (await ethers.provider.getBalance(nftAddress)).toString());

}
main().catch(console.error)

