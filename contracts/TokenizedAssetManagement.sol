// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./AssetToken.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract TokenizedAssetManagement {
    address public owner;
    AggregatorV3Interface internal priceFeed;
        // Hardcoded Chainlink ETH/USD price feed address
    address constant priceFeedAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;


    struct Asset {
        address creator;
        address tokenAddress;
        string uri;
        uint256 priceUSD; // Price of the asset in USD per token
    }

    mapping(address => Asset) public assets; // Map token address to asset details

    event AssetCreated(address indexed creator, address indexed tokenAddress, string uri, uint256 priceUSD);
    event AssetBought(address indexed buyer, address indexed tokenAddress, uint256 amount);

    constructor() {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress); // Chainlink ETH/USD price feed
    }

    function createAsset(
        string memory name,
        string memory symbol,
        uint256 totalSupply,
        uint256 priceUSD,
        string memory uri
    ) external {
        // Create a new token
        AssetToken token = new AssetToken(name, symbol, totalSupply, address(this));

        // Grant this contract the MINTER_ROLE to enable minting tokens
        //token.grantRole(token.MINTER_ROLE(), address(this));

        // Record the new asset in the management contract
        assets[address(token)] = Asset(msg.sender, address(token), uri, priceUSD);

        // Emit an event indicating creation of the asset
        emit AssetCreated(msg.sender, address(token), uri, priceUSD);
    }


    function getLatestPrice() internal view returns (int256) {
        (, int256 price,,,) = priceFeed.latestRoundData();
        return price;
    }

function buyAsset(address tokenAddress) external payable {
    Asset memory asset = assets[tokenAddress];
    require(asset.tokenAddress != address(0), "Asset does not exist");

    int256 ethUSDPrice = 3000;// getLatestPrice(); // Get the current ETH/USD price
    require(ethUSDPrice > 0, "Invalid ETH/USD price");

    uint256 ethInUSD = (msg.value * uint256(ethUSDPrice)) / 1e8; // Chainlink price feeds have 8 decimals
    require(ethInUSD > 0, "Insufficient payment");

    uint256 tokensToTransfer = ethInUSD * 1e18 / asset.priceUSD; // 1e18 to adjust for decimal places

    AssetToken token = AssetToken(tokenAddress);
    require(token.totalMinted() + tokensToTransfer <= token.maxSupply(), "Max supply exceeded");

    // Mint tokens directly to the buyer's address
    token.mint(msg.sender, tokensToTransfer);

    emit AssetBought(msg.sender, tokenAddress, tokensToTransfer);
}

}
