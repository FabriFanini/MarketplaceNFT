// SPDX-License-Identifier: MIT
pragma solidity  >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract fabriNFT is ERC721, Ownable{

    uint256 _tokenId;

    constructor() ERC721("Fabri NFT Collection","FNFT") Ownable(msg.sender){
        _tokenId = 0;
    }

    function mintFabriNFT (address to) external onlyOwner returns (uint256){
        _tokenId = _tokenId + 1;
        _safeMint(to, _tokenId);
        return _tokenId;
    }

    function currentTokenId () external view returns(uint256){
        return _tokenId;
    }
}