// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "openzeppelin/contracts/access/Ownable.sol"

contract dNFT is ERC721, Ownable{

    uint256 private _nextTokenId;
    uint256 public maxSupply;
    uint256 public mintPrice;
    string private baseTokenURI;

    constructor(string memory baseURI, uint256 _maxSupply, uint256 _mintPrice) ERC721("LondyNFT", "LNFT") Onwable(msg.sender){
        baseTokenURI = baseURI;
        maxSupply = _maxSupply;
        mintPrice = _mintPrice;

    }


    //mint NFT, one at a time
    function mint() external payable {
        require(_nextTokenId <= maxSupply, "No more NFT to mint");
        require(msg.value >= mintPrice, "Insufficient funds!");

        uint256 tokenId = _nextTokenId;

        _safeMint(msg.sender, tokenId);
        _nextTokenId++;

    }

    function ownerMint() external onlyOwner {
        require(_nextTokenId <= maxSupply, "No more NFT to mint");

        uint256 tokenId = _nextTokenId;

        _safeMint(msg.sender, tokenId);
        _nextTokenId++;
    }

    //how many tokens have been minted for far
    function totalSupply() public view returns(uint256){
        return _nextTokenId;
    }

    //assign the base  to our state variable
    function _baseURI() internal view override returns (string memory){
        return baseTokenURI;
    }

    //set baseURI to new link
    function setBaseURI(string memory newBaseURI) external onlyOwner {
        baseTokenURI = newBaseURI;
    }

    //owner withdraws funds from selling NFTs
    function withdraw() external onlyOwner {
        require(address(this).balance == 0, "No funds in contract");
        payable(owner()).transfer(address(this).balance);
    }

}
