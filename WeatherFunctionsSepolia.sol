// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Deploy on Sepolia

import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/FunctionsClient.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/libraries/FunctionsRequest.sol";

contract WeatherFunctions is FunctionsClient {
    using FunctionsRequest for FunctionsRequest.Request;

    // State variables to store the last request ID, response, and error
    bytes32 public lastRequestId;
    bytes public lastResponse;
    bytes public lastError;

    struct RequestStatus {
        bool fulfilled; // whether the request has been successfully fulfilled
        bool exists; // whether a requestId exists
        bytes response;
        bytes err;
    }
    mapping(bytes32 => RequestStatus) public requests; /* requestId --> requestStatus */          
    bytes32[] public requestIds;

    // Event to log responses
    event Response(
        bytes32 indexed requestId,
        string temperature,
        bytes response,
        bytes err
    );

    // Hardcoded for Sepolia
    // Supported networks https://docs.chain.link/chainlink-functions/supported-networks
    address router = 0xb83E47C2bC239B3bf370bc41e1459A34b41238D0;
    bytes32 donID =
        0x66756e2d657468657265756d2d7365706f6c69612d3100000000000000000000;

    //Callback gas limit
    uint32 gasLimit = 300000;

    // Your subscription ID.
    uint64 public subscriptionId;

    // JavaScript source code
    string public source =
        "const city = args[0];"
        "const apiResponse = await Functions.makeHttpRequest({"
        "url: `https://wttr.in/${city}?format=3&m`,"
        "responseType: 'text'"
        "});"
        "if (apiResponse.error) {"
        "throw Error('Request failed');"
        "}"
        "const { data } = apiResponse;"
        "return Functions.encodeString(data);";
    string public lastCity;    
    string public lastTemperature;
    address public lastSender;

    struct CityStruct {
        address sender;
        uint timestamp;
        string name;
        string temperature;
    }
    CityStruct[] public cities;
    mapping(string => uint256) public cityIndex;
    mapping(bytes32 => string) public request_city; /* requestId --> city*/

    constructor(uint64 functionsSubscriptionId) FunctionsClient(router) {
        subscriptionId = functionsSubscriptionId;      
    }

    function getTemperature(
        string memory _city
    ) external returns (bytes32 requestId) {

        string[] memory args = new string[](1);
        args[0] = _city;

        FunctionsRequest.Request memory req;
        req.initializeRequestForInlineJavaScript(source); // Initialize the request with JS code
        if (args.length > 0) req.setArgs(args); // Set the arguments for the request

        // Send the request and store the request ID
        lastRequestId = _sendRequest(
            req.encodeCBOR(),
            subscriptionId,
            gasLimit,
            donID
        );
        lastCity = _city;
        request_city[lastRequestId] = _city;

        CityStruct memory auxCityStruct = CityStruct({
            sender: msg.sender,
            timestamp: 0,
            name: _city,
            temperature: ""            
        });
        cities.push(auxCityStruct);
        cityIndex[_city] = cities.length-1;

        requests[lastRequestId] = RequestStatus({
            exists: true,
            fulfilled: false,
            response: "",
            err: ""
        });
        requestIds.push(lastRequestId);

        return lastRequestId;
    }

    // Receive the weather in the city requested
    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        require(requests[requestId].exists, "request not found");

        lastError = err;
        lastResponse = response;

        requests[requestId].fulfilled = true;
        requests[requestId].response = response;
        requests[requestId].err = err;

        string memory auxCity = request_city[requestId];
        lastTemperature = string(response);
        cities[cityIndex[auxCity]].temperature = lastTemperature;
        cities[cityIndex[auxCity]].timestamp = block.timestamp;

        // Emit an event to log the response
        emit Response(requestId, lastTemperature, lastResponse, lastError);
    }

	function getCity(string memory city) public view returns (CityStruct memory) {
    	return cities[cityIndex[city]];
	}

	function listAllCities() public view returns (CityStruct[] memory) {
    	return cities;
	}

    function listCities(uint start, uint end) public view returns (CityStruct[] memory) {
        if (end > cities.length)
            end = cities.length-1;
        require (start <= end, "start must <= end");
        uint cityCount = end - start + 1;
        CityStruct[] memory citiesAux = new CityStruct[](cityCount);

        for (uint i = start; i < (end + 1); i++) {
            citiesAux[i-start] = cities[i];
        }
        return citiesAux;
    }

}