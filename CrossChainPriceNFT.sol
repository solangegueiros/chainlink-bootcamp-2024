// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Deploy this contract on Sepolia

// Importing OpenZeppelin contracts
import "@openzeppelin/contracts@4.6.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@4.6.0/utils/Counters.sol";
import "@openzeppelin/contracts@4.6.0/utils/Base64.sol";

// Importing Chainlink contracts
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract CrossChainPriceNFT is ERC721, ERC721URIStorage {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter public tokenIdCounter;

    // Create price feed
    AggregatorV3Interface internal priceFeed;
    uint256 public lastPrice = 0;

    string priceIndicatorUp = unicode"😀";
    string priceIndicatorDown = unicode"😔";
    string priceIndicatorFlat = unicode"😑";
    string public priceIndicator;

    struct ChainStruct {
        uint64 code;
        string name;
        string color;
    }
    mapping (uint256 => ChainStruct) chain;

    //https://docs.chain.link/ccip/supported-networks/testnet
    constructor() ERC721("CrossChain Price", "CCPrice") {
        chain[0] = ChainStruct ({
            code: 16015286601757825753,
            name: "Sepolia",
            color: "#0000ff" //blue
        });
        chain[1] = ChainStruct ({
            code: 14767482510784806043,
            name: "Fuji",
            color: "#ff0000" //red
        });
        chain[2] = ChainStruct ({
            code: 12532609583862916517,
            name: "Mumbai",
            color: "#4b006e" //purple
        });

        // https://docs.chain.link/data-feeds/price-feeds/addresses        
        priceFeed = AggregatorV3Interface(
            // Sepolia BTC/USD
            0x1b44F3514812d835EB1BDB0acB33d3fA3351Ee43            
        );

        // Mint an NFT
        mint(msg.sender);
    }

    function mint(address to) public {
        // Mint from Sepolia network = chain[0]
        mintFrom(to, 0);
    }

    function mintFrom(address to, uint256 sourceId) public {
        // sourceId 0 Sepolia, 1 Fuji, 2 Mumbai
        uint256 tokenId = tokenIdCounter.current();
        _safeMint(to, tokenId);
        updateMetaData(tokenId, sourceId);    
        tokenIdCounter.increment();
    }

    // Update MetaData
    function updateMetaData(uint256 tokenId, uint256 sourceId) public {
        // Create the SVG string
        string memory finalSVG = buildSVG(sourceId);
           
        // Base64 encode the SVG
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Cross-chain Price SVG",',
                        '"description": "SVG NFTs in different chains",',
                        '"image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSVG)), '",',
                        '"attributes": [',
                            '{"trait_type": "source",',
                            '"value": "', chain[sourceId].name ,'"},',
                            '{"trait_type": "price",',
                            '"value": "', lastPrice.toString() ,'"}',
                        ']}'
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
    function buildSVG(uint256 sourceId) internal returns (string memory) {

        // Create SVG rectangle with random color
        string memory headSVG = string(
            abi.encodePacked(
                "<svg xmlns='http://www.w3.org/2000/svg' version='1.1' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:svgjs='http://svgjs.com/svgjs' width='500' height='500' preserveAspectRatio='none' viewBox='0 0 500 500'> <rect width='100%' height='100%' fill='",
                chain[sourceId].color,
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

    function tokenURI(uint256 tokenId)
        public view override(ERC721, ERC721URIStorage) returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    // The following function is an override required by Solidity.
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }
}