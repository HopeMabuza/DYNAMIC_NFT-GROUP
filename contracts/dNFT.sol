// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";

contract dNFT is Initializable, ERC721Upgradeable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 private _nextTokenId;
    uint256 public maxSupply;
    uint256 public mintPrice;
    string private baseTokenURI;

    ///@custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(uint256 _maxSupply, uint256 _mintPrice) public initializer {
        __ERC721_init("Galaxy NFT", "gNFT");
        __Ownable_init(msg.sender);

        maxSupply = _maxSupply;
        mintPrice = _mintPrice;
    }

    function mint() external payable {
        require(_nextTokenId < maxSupply, "No more NFT to mint");
        require(msg.value >= mintPrice, "Insufficient funds!");
        require(balanceOf(msg.sender) == 0, "Cannot mint more than one NFT");

        uint256 tokenId = _nextTokenId;
        _safeMint(msg.sender, tokenId);
        _nextTokenId++;
    }

    function ownerMint() external onlyOwner {
        require(_nextTokenId < maxSupply, "No more NFT to mint");
        require(balanceOf(msg.sender) == 0, "Cannot mint more than one NFT");

        uint256 tokenId = _nextTokenId;
        _safeMint(msg.sender, tokenId);
        _nextTokenId++;
    }

    function totalSupply() public view returns (uint256) {
        return _nextTokenId;
    }

    function changeMintPrice(uint256 newPrice) internal onlyOwner {
        mintPrice = newPrice;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function setBaseURI(string memory newBaseURI) external onlyOwner {
        baseTokenURI = newBaseURI;
    }

    function withdraw() external onlyOwner {
        require(address(this).balance > 0, "No funds in contract");
        payable(owner()).transfer(address(this).balance);
    }

    //our NFT is SoulBound: that means once you own it, you cannot transfer ownership to someone else.
    //We need to add that logic in transfer related functions
    //we want the transaction to revet whenever the owner tries to transfer
    //the main function that every transfer goes through is _update
    function _update(address to, uint256 tokenId, address auth) internal override returns (address){
        //get the owner of the nft
        address from = _ownerOf(tokenId);

        //we need to only allow transfer if the nft has no owner (address(0))
        require(from == address(0), "Cannot transfer NFT to another owner");

        return super._update(to, tokenId, auth);

    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner{

    }
    
}
