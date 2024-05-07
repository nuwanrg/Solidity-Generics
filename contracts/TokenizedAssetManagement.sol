// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./AssetToken2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract TokenizedAssetManagement {
    address public owner;
    AggregatorV3Interface internal priceFeed;

    struct Asset {
        address creator;
        address tokenAddress;
        string uri;
        uint256 priceUSD; // Price of the asset in USD per token
    }

    mapping(address => Asset) public assets;

    event AssetCreated(
        address indexed creator,
        address indexed tokenAddress,
        string uri,
        uint256 priceUSD
    );
    event AssetBought(
        address indexed buyer,
        address indexed tokenAddress,
        uint256 amount
    );

    address constant priceFeedAddress = 0x694AA1769357215DE4FAC081bf1f309aDC325306;

    constructor() {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress); // Chainlink ETH/USD price feed
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function createAsset(
        string memory name,
        string memory symbol,
        uint256 totalSupply,
        uint256 priceUSD,
        string memory uri
    ) external {
        AssetToken2 token = new AssetToken2(name, symbol, totalSupply, msg.sender);
        token.setAuthorizedContract(address(this)); // Authorize this contract to transfer tokens

        // assets[address(token)] = Asset(msg.sender, address(token), uri, priceUSD);
        emit AssetCreated(msg.sender, address(token), uri, priceUSD);
    }

    function getLatestPrice() internal view returns (int256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return price;
    }


        function buyAsset(address tokenAddress) external payable {
        Asset memory asset = assets[tokenAddress];
        require(asset.tokenAddress != address(0), "Asset does not exist");

        int256 ethUSDPrice = 3000;//getLatestPrice(); // Get the current ETH/USD price
        require(ethUSDPrice > 0, "Invalid ETH/USD price");

        uint256 ethInUSD = (msg.value * uint256(ethUSDPrice)) / 1e8; // Chainlink price feeds have 8 decimals
        require(ethInUSD > 0, "Insufficient payment");

        uint256 tokensToTransfer = ethInUSD * 1e18 / asset.priceUSD; // 1e18 to adjust for decimal places

        AssetToken2 token = AssetToken2(tokenAddress);
        require(token.balanceOf(asset.creator) >= tokensToTransfer, "Not enough tokens available");

        // Transfer tokens directly from creator to buyer using custom function
        token.authorizedTransfer(asset.creator, msg.sender, tokensToTransfer);

        emit AssetBought(msg.sender, tokenAddress, tokensToTransfer);
        }
}
