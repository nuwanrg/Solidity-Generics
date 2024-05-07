// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AssetToken is ERC20, Ownable {
    uint256 public immutable maxSupply;

    constructor(
        string memory name,
        string memory symbol,
        uint256 _maxSupply,
       address initialOwner
    ) ERC20(name, symbol) Ownable(initialOwner){ // Pass name and symbol to the ERC20 constructor
        require(_maxSupply > 0, "Max supply must be greater than zero");
        maxSupply = _maxSupply * 10 ** 18;
        _mint(initialOwner, maxSupply); // Initially mint all tokens to the owner
    }

    // Function to mint new tokens (only callable by the owner)
    function mint(address to, uint256 amount) external onlyOwner {
        require(totalSupply() + amount <= maxSupply, "Max supply exceeded");
        _mint(to, amount);
    }
}

