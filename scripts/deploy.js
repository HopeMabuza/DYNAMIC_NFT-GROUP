const { ethers, upgrades} = require("hardhat");

async function main(){
    const[owner, user1] = await ethers.getSigners();

    const NFT = await ethers.getContractFactory("dNFT");
    const mintPrice = ethers.parseEther("0.0001");
    const nft = await upgrades.deployProxy(NFT, [20, mintPrice ], {kind: 'uups'});
    await nft.waitForDeployment();

    const proxyAddress = await nft.getAddress();
    const implementationAddress = await upgrades.erc1967.getImplementationAddress(proxyAddress);

    console.log("Proxy Address: ", proxyAddress);
    console.log("Implementation Address: ", implementationAddress);



}
main().catch(console.error)

