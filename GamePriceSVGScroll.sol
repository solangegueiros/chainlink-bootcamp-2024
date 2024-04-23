// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Deploy this contract on Scroll Sepolia

// Importing OpenZeppelin contracts
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.6.0/utils/Base64.sol";

// Importing Chainlink contracts
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract GamePriceSVG is ERC721, ERC721URIStorage {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter public tokenIdCounter;

    // Create price feed
    AggregatorV3Interface internal priceFeed;
    uint256 public lastPrice = 0;

    // Set variables for NFT
    string priceIndicatorUp = unicode"😀";
    string priceIndicatorDown = unicode"😔";
    string priceIndicatorFlat = unicode"😑";
    string public priceIndicator;

    string[] public colors = [ 
        "ff0000",
        "ffff00",
        "00ff00",
        "0000ff",
        "00ff00",
        "808080",
        "ff00ff"
    ];
    uint8 public actualColor = 0;

    // https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1
    /**
     * Network: Scroll Sepolia
     * Aggregator: BTC/USD
     */
    address btcuscAddress = 0x87dce67002e66C17BC0d723Fe20D736b80CAaFda;

    constructor() ERC721("Price Feed SVG", "pfSVG") {
        priceFeed = AggregatorV3Interface(btcuscAddress);
        
        // Mint an NFT
        safeMint();
    }

    function safeMint() public {
        uint256 tokenId = tokenIdCounter.current();
        tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
        updateSVG(tokenId);
    }

    // Update the SVG
    function updateSVG(uint256 tokenId) public {
        // Create the SVG string
        string memory finalSVG = buildSVG();
        // Base64 encode the SVG
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Price Feed SVG",',
                        '"description": "SVG NFTs based on asset price",',
                        '"image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSVG)),
                        '"}'
                    )
                )
            )
        );
        // Create token URI
        string memory finalTokenURI = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        // Set token URI
        _setTokenURI(tokenId, finalTokenURI);
    }

    // Build the SVG string
    function buildSVG() internal returns (string memory) {
        actualColor = actualColor + 1;
        if (actualColor == colors.length) {
            actualColor = 0;
        }            
        string memory fillColor = string(abi.encodePacked("#", colors[actualColor]));

        // Create SVG rectangle with another color
        string memory headSVG = string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' version='1.1' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:svgjs='http://svgjs.com/svgjs' width='500' height='500' preserveAspectRatio='none' viewBox='0 0 500 500'> <rect width='100%' height='100%' fill='",
                fillColor,
                "' />"
            )
        );
        // Update emoji based on price
        string memory bodySVG = string(
            abi.encodePacked(
                "<text x='50%' y='50%' font-size='128' dominant-baseline='middle' text-anchor='middle'>",
                comparePrice(),
                "</text>"
            )
        );
        // Close SVG
        string memory tailSVG = "</svg>";

        // Concatenate SVG strings
        string memory _finalSVG = string(
            abi.encodePacked(headSVG, bodySVG, tailSVG)
        );
        return _finalSVG;
    }

    // Compare new price to previous price
    function comparePrice() public returns (string memory) {
        uint256 currentPrice = getChainlinkDataFeedLatestAnswer();
        if (currentPrice > lastPrice) {
            priceIndicator = priceIndicatorUp;
        } else if (currentPrice < lastPrice) {
            priceIndicator = priceIndicatorDown;
        } else {
            priceIndicator = priceIndicatorFlat;
        }
        lastPrice = currentPrice;
        return priceIndicator;
    }

    function getChainlinkDataFeedLatestAnswer() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price);
    }

    // The following function is an override required by Solidity.
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public view override(ERC721, ERC721URIStorage) returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}