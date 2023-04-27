// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

/*
SALCHAIN will not be liable in any way if for the use of the code.
Users should proceed with caution and use it at their own risk.
*/

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SalchainNFTWhiteList is ERC721Enumerable, Ownable {

   using Strings for uint256;

   string public baseURI;                       
   string public baseExtension = ".json";
   uint256 public costPre = 0.00002 ether;     // PreSale Price for NFT Mint
   uint256 public costPublic = 0.0002 ether;   // Public Sale Price for NFT Mint
   uint256 public maxSupply = 20;              // Max total nft 

//new
    bool public publicMintActive = false;
    bool public whiteListMintActive = false;

    mapping(address => bool) public whitelisted;


   constructor(
       string memory _name, // token name 
       string memory _symbol, // token symbol 
       string memory _initBaseURI // token metdata 
   ) 
   ERC721(_name, _symbol) {
       setBaseURI(_initBaseURI); // ipfs://..../
   }


   function _baseURI() internal view virtual override returns (string memory) {
       return baseURI;
   }

   function whitelistMint (uint256 _mintAmount) public payable {
       require(whiteListMintActive, "White List Mint Not Actived");
       require(whitelisted[msg.sender], "You are not on the White list");
       require(msg.value >= costPre * _mintAmount, "Not enough ETH for transaction");
       internalMint(_mintAmount);

   }

   function publicMint(uint256 _mintAmount) public payable {
       require(publicMintActive, "Public Mint Not Actived" );
       require(msg.value >= costPublic * _mintAmount, "Not enough ETH for transaction");
       internalMint(_mintAmount);
   }

   function internalMint(uint256 _mintAmount) internal {
       uint256 supply = totalSupply();
       require(_mintAmount > 0, "need to mint at least 1 NFT");
       require(supply + _mintAmount <= maxSupply, "Max supply exceeded!");

       for (uint256 i = 1; i <= _mintAmount; i++) {
           _safeMint(msg.sender, supply + i);
       }
   }

   //
    function walletOfOwner(address _owner) public view returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory)
    {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0
                ? string(abi.encodePacked(currentBaseURI,tokenId.toString(),baseExtension))
                : "";
    }



  function editMintState (
       bool _publicMintActive, bool _whiteListMintActive
       ) external onlyOwner {
           publicMintActive = _publicMintActive;
           whiteListMintActive = _whiteListMintActive;
       }
    
    function setWhiteList(address[] calldata addresses) external onlyOwner {
        for (uint256 i =0; i< addresses.length; i++){
            whitelisted[addresses[i]] = true;
        }
    }

    function withdraw(address _addr) external onlyOwner {

        uint balance = address(this).balance;
        payable(_addr).transfer(balance);
    }



   function setBaseURI(string memory _newBaseURI) public onlyOwner {
       baseURI = _newBaseURI;
   }

   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
       baseExtension = _newBaseExtension;
   }

}
