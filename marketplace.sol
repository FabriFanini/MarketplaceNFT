// SPDX-License-Identifier: MIT
pragma solidity  >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "./tokens/ERC20.sol";
import "./tokens/ERC721.sol";

contract MarketplaceNFT is Ownable, ERC721Holder{
    //Errors
    error MarketplaceMintingError();
    error MarketplaceNFTInsufficientFunds();
    error FabriNFTNonAvailable();

    //Events
    event NFTaddedToMarketplace(uint256 tokenId);
    event NFTPurchased (address to, uint256 tokenId);

    //Variables
    fabriERC20 public erc20Contract;
    fabriNFT public nftContract;

    uint256 public nftPrice = 0.01 ether;
    uint256 public rewardTokens = 20 * 10 ** 18;

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
            revert MarketplaceMintingError();
        }

        AvailableToken[tokenId] = true;

        emit NFTaddedToMarketplace(tokenId);
    }

    function buyFabriNFT (uint256 tokenId) external payable {
        if (msg.value < nftPrice) {
            revert MarketplaceNFTInsufficientFunds();
        }

        if (!AvailableToken[tokenId]){
            revert FabriNFTNonAvailable();
        }

        AvailableToken[tokenId] = false;
        nftContract.safeTransferFrom(address(this), msg.sender, tokenId);

        uint256 excessAmount = msg.value - nftPrice;
        if (excessAmount > 0){
            (bool success, ) = msg.sender.call{value: excessAmount}("");
            require (success, "Refund Failed");
        }

        erc20Contract.mintFabriERC20(msg.sender, rewardTokens);

        emit NFTPurchased (msg.sender, tokenId);
    }

    function setNFTPrice (uint256 _NFTPrice) external onlyOwner {
        nftPrice = _NFTPrice;
    }

    function setRewardTokens (uint256 _rewardTokens) external onlyOwner{
        rewardTokens = _rewardTokens;
    }

    function withdraw () external onlyOwner{
        payable(owner()).transfer(address(this).balance);
    }

    function getERC20Address () external view returns (address){
        return address(erc20Contract);
    }

    function getNFTAddress () external view returns (address){
        return address(nftContract);
    }

    function getAvailablesNFTs() external view returns(uint256 [] memory){
        uint256 totalSupply = nftContract.currentTokenId();
        uint256 count = 0;

        for (uint256 i = 1; i <= totalSupply; i++){
            if (AvailableToken[i]){
                count = count + 1;
            }
        }

        uint256[] memory tokendIds = new uint256[](count); 
        uint256 index = 0;

        for (uint256 i = 1; i <= totalSupply; i++){
            if (AvailableToken[i]){
                tokendIds[index] = i;
                index ++;
            }
        }
        
        return tokendIds;
    }


}