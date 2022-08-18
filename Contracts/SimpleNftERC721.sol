// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;
/*
SALCHAIN will not be liable in any way if for the use of the code.
Users should proceed with caution and use it at their own risk.
*/
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SalchainNFT1 is ERC721Enumerable, Ownable {

   using Strings for uint256;

   string public baseURI; // The Base URL where to store the data and image of the NFT
   string public baseExtension = ".json";
   uint256 public cost = 0.05 ether;  
   uint256 public maxSupply = 20; // max total nft 

   constructor(
       string memory _name, // token name 
       string memory _symbol, // token symbol 
       string memory _initBaseURI // token metdata 
   ) 
   ERC721(_name, _symbol) {
       setBaseURI(_initBaseURI);
       mint(msg.sender, 4); // mint at the initial run 
   }

   function _baseURI() internal view virtual override returns (string memory) {
       return baseURI;
   }

   function mint(address _to, uint256 _mintAmount) public payable {
       uint256 supply = totalSupply();
       require(_mintAmount > 0);
       require(supply + _mintAmount <= maxSupply);

       for (uint256 i = 1; i <= _mintAmount; i++) {
           _safeMint(_to, supply + i);
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


   //

   function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }

   function setBaseURI(string memory _newBaseURI) public onlyOwner {
       baseURI = _newBaseURI;
   }

   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
       baseExtension = _newBaseExtension;
   }

}
