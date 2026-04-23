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
    string private baseURI;

    mapping (uint256 => uint256) public tokensSiteVisits;

    // Reserve slot gap
    uint256[50] private __gap;

    event MintedNFT(uint256 tokenId, address owner);
    event PointUpdated(uint256 tokenId, uint256 points);
    event UpdatedMetadata(uint256 tokenId);

    ///@custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(uint256 _maxSupply, uint256 _mintPrice, string memory _baseURI) public initializer {
        __ERC721_init("Dymanic NFT", "dNFT");
        __Ownable_init(msg.sender);

        maxSupply = _maxSupply;
        mintPrice = _mintPrice;
        baseURI= _baseURI;
    }

    function mint() external payable {
        require(_nextTokenId < maxSupply, "No more NFT to mint");
        require(msg.value == mintPrice, "Minting requires ETH");
       
        uint256 tokenId = _nextTokenId;
        _safeMint(msg.sender, tokenId);
        tokensSiteVisits[_nextTokenId] = 0;
        _nextTokenId++;

        emit MintedNFT(_nextTokenId - 1, msg.sender);
    }

    function ownerMint() external onlyOwner {
        require(_nextTokenId < maxSupply, "No more NFT to mint");
        
        uint256 tokenId = _nextTokenId;
        _safeMint(msg.sender, tokenId);
        _nextTokenId++;

        emit MintedNFT(_nextTokenId - 1, msg.sender);
    }

    function totalSupply() public view returns (uint256) {
        return _nextTokenId;
    }

    function setBaseURI(string memory newBaseURI) external onlyOwner {
        baseURI = newBaseURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory){
        require(_ownerOf(tokenId) != address(0), "ERC721Metadata: URI query for nonexistent token");
        require(_ownerOf(tokenId) == msg.sender, "You are not the owner of this token");

        if (tokensSiteVisits[tokenId] < 10) {
            return string(abi.encodePacked(baseURI, "0.json"));
        } else {
            return string(abi.encodePacked(baseURI, "1.json"));
        }
    }

    function withdraw() external onlyOwner {
        require(address(this).balance > 0, "No funds in contract");
        payable(owner()).transfer(address(this).balance);
    }

    function updatePoints(uint256 tokenId, uint256 points) public onlyOwner {
        tokensSiteVisits[tokenId] = tokensSiteVisits[tokenId] + points;

        emit PointUpdated(tokenId, tokensSiteVisits[tokenId]);
        emit UpdatedMetadata(tokenId);
    }

    //our NFT is SoulBound: that means once you own it, you cannot transfer ownership to someone else.
    //We need to add that logic in transfer related functions
    //we want the transaction to revet whenever the owner tries to transfer
    //the main function that every transfer goes through is _update
    function _update(address to, uint256 tokenId, address auth) internal virtual override returns (address) {
            address from = _ownerOf(tokenId);
            
            if (from != address(0) && to != address(0)) {
                revert("This NFT is Soulbound and cannot be transferred.");
            }

            return super._update(to, tokenId, auth);
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner{

    }
    
}
