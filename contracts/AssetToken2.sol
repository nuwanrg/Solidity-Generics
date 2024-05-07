// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AssetToken2 is ERC20, Ownable {
    uint256 public immutable maxSupply;
    address public authorizedContract; // Contract allowed to transfer tokens

    constructor(
        string memory name,
        string memory symbol,
        uint256 _maxSupply,
        address owner
    ) ERC20(name, symbol) Ownable(owner){
        require(_maxSupply > 0, "Max supply must be greater than zero");
        maxSupply = _maxSupply * 10 ** 18;
        _mint(owner, maxSupply); // Initially mint all tokens to the creator
    }

    // Set the contract that is allowed to transfer tokens directly
    function setAuthorizedContract(address _contract) external onlyOwner {
        authorizedContract = _contract;
    }

    // Allow authorized contract to transfer tokens from one address to another
    function authorizedTransfer(address from, address to, uint256 amount) external {
        require(msg.sender == authorizedContract, "Not authorized");
        _transfer(from, to, amount);
    }
}
