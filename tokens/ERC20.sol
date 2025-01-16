// SPDX-License-Identifier: MIT
pragma solidity  >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract fabriERC20 is ERC20, Ownable{

    constructor() ERC20("Fabri ERC20", "FE20") Ownable(msg.sender){
    }

    function mintFabriERC20 (address account, uint256 value) external onlyOwner{
        _mint(account, value);
    }

}