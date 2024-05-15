// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract AssetToken is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 public immutable maxSupply;
    uint256 public totalMinted;  // Track the amount of tokens minted

    constructor(
        string memory name,
        string memory symbol,
        uint256 _maxSupply,
        address admin
    ) ERC20(name, symbol) {
        maxSupply = _maxSupply * 10 ** 18; // Store the maximum supply in smallest units
        _grantRole(DEFAULT_ADMIN_ROLE, admin);
        //grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        grantRole(MINTER_ROLE, admin);
        // grantRole(DEFAULT_ADMIN_ROLE, msg.sender);  // Assign the default admin role to the deployer
        // grantRole(MINTER_ROLE, msg.sender);  // Assign the minter role to the deployer
    }

    function mint(address to, uint256 amount) public {
        require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
        require(totalMinted + amount <= maxSupply, "Cannot mint more than the max supply");
        _mint(to, amount);
        totalMinted += amount;  // Update the total minted amount
    }
}
