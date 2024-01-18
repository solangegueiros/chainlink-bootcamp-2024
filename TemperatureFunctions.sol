// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Deploy on Fuji

import {FunctionsClient} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/FunctionsClient.sol";
import {ConfirmedOwner} from "@chainlink/contracts/src/v0.8/shared/access/ConfirmedOwner.sol";
import {FunctionsRequest} from "@chainlink/contracts/src/v0.8/functions/dev/v1_0_0/libraries/FunctionsRequest.sol";

contract TemperatureFunctions is FunctionsClient {
    using FunctionsRequest for FunctionsRequest.Request;

    // State variables to store the last request ID, response, and error
    bytes32 public s_lastRequestId;
    bytes public s_lastResponse;
    bytes public s_lastError;

    // Custom error type
    error UnexpectedRequestID(bytes32 requestId);

    // Event to log responses
    event Response(
        bytes32 indexed requestId,
        string temperature,
        bytes response,
        bytes err
    );

    // Hardcoded for Fuji
    // Supported networks https://docs.chain.link/chainlink-functions/supported-networks
    address router = 0xA9d587a00A31A52Ed70D6026794a8FC5E2F5dCb0;
    bytes32 donID =
        0x66756e2d6176616c616e6368652d66756a692d31000000000000000000000000;

    //Callback gas limit
    uint32 gasLimit = 300000;

    // Your subscription ID.
    uint64 public s_subscriptionId;

    // JavaScript source code    
    string public source =
        "const city = args[0];"
        "const apiResponse = await Functions.makeHttpRequest({"
        "url: `https://wttr.in/${city}?format=3`,"
        "responseType: 'text'"
        "});"
        "if (apiResponse.error) {"
        "throw Error('Request failed');"
        "}"
        "const { data } = apiResponse;"
        "return Functions.encodeString(data);";
    string public lastCity;    
    string public lastTemperature;

    constructor(uint64 subscriptionId) FunctionsClient(router) {
        s_subscriptionId = subscriptionId;
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
        s_lastRequestId = _sendRequest(
            req.encodeCBOR(),
            s_subscriptionId,
            gasLimit,
            donID
        );
        lastCity = _city;

        return s_lastRequestId;
    }

    /**
     * @notice Callback function for fulfilling a request
     * @param requestId The ID of the request to fulfill
     * @param response The HTTP response data
     * @param err Any errors from the Functions request
     */
    function fulfillRequest(
        bytes32 requestId,
        bytes memory response,
        bytes memory err
    ) internal override {
        if (s_lastRequestId != requestId) {
            revert UnexpectedRequestID(requestId); // Check if request IDs match
        }        
        s_lastError = err;

        // Update the contract's state variables with the response and any errors
        s_lastResponse = response;
        lastTemperature = string(response);

        // Emit an event to log the response
        emit Response(requestId, lastTemperature, s_lastResponse, s_lastError);
    }
}
