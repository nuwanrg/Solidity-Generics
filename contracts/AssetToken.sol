// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract AssetToken is ERC20, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    uint256 public immutable maxSupply;

    constructor(
        string memory name,
        string memory symbol,
        uint256 _maxSupply,
        address minter
    ) ERC20(name, symbol) {
        grantRole(MINTER_ROLE, minter);
        maxSupply = _maxSupply * 10 ** 18;
        _mint(minter, maxSupply); // Initially mint all tokens to the minter
    }

    function mint(address to, uint256 amount) public {
        require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
        _mint(to, amount);
    }
}

