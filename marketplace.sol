// SPDX-License-Identifier: MIT
pragma solidity  >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "./tokens/ERC20.sol";
import "./tokens/ERC721.sol";

contract MarketplaceNFT is Ownable {
    //Errors
    error FabriMarketplaceMintingError();

    //Events
    event NFTaddedToMarketplace(uint256 tokenId);

    //Variables
    fabriERC20 public erc20Contract;
    fabriNFT public nftContract;

    //Mappings
    mapping (uint256 tokenId => bool) AvailableToken;

    //Constructor
    constructor() Ownable(msg.sender) {
        erc20Contract = new fabriERC20();
        nftContract = new fabriNFT();

    }

    //Functions
    function addNFTToMarketplace () external onlyOwner{
        uint256 tokenId = nftContract.mintFabriNFT(address(this));

        if (tokenId == 0){
            revert FabriMarketplaceMintingError();
        }

        AvailableToken[tokenId] = true;

        emit NFTaddedToMarketplace(tokenId);
    }
}