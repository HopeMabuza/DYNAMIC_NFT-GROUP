const { parseEther, formatEther } = require("ethers");
const { ethers, upgrades } = require("hardhat");

async function main() {
    const [deployer, user1, user2] = await ethers.getSigners();

    console.log("Deploying contract....");
    const NFT = await ethers.getContractFactory("dNFT");
    const mintPrice = parseEther("0.0001");
    const nft = await NFT.deploy("null", 10, mintPrice);
    await nft.waitForDeployment();

    const nftAddress = await nft.getAddress();
    console.log("Contract address: ", nftAddress);

    console.log("Checking contract state......");
    console.log("NFT name: ", await nft.name());
    console.log("NFT symbol: ", await nft.symbol());
    console.log("NFT price: ", await nft.mintPrice());
    console.log("NFT max supply: ", await nft.maxSupply());
    console.log("People owning NFTs: ", await nft.totalSupply());
    console.log("Contract balance: ", formatEther(await ethers.provider.getBalance(nftAddress)));

    console.log("Minting NFT as owner....");
    await nft.ownerMint();
    console.log("People owning NFTs: ", await nft.totalSupply());
    console.log("Contract balance: ", formatEther(await ethers.provider.getBalance(nftAddress)));

    console.log("Minting NFT as user1....");
    await nft.connect(user1).mint({value: mintPrice});
    console.log("People owning NFTs: ", await nft.totalSupply());
    console.log("Contract balance: ", formatEther(await ethers.provider.getBalance(nftAddress)));
    
    console.log("Checking if user1 owns an NFT.....");
    console.log("User1 owns NFT: ", await nft.connect(user1).ownerOf(1));

    }
    main().catch(console.error);


    


    




    


