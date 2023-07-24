// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IMOSV3 {

    enum ChainType{
        NULL,
        EVM,
        NEAR
    }

    enum MessageType {
        CALLDATA,
        MESSAGE
    }

    struct MessageData {
        bool relay;
        MessageType msgType;
        bytes target;
        bytes payload;
        uint256 gasLimit;
        uint256 value;
    }

    function getMessageFee(uint256 toChain, address feeToken, uint256 gasLimit) external view returns (uint256, address);

    function transferOut(uint256 toChain, bytes memory messageData, address feeToken) external payable returns (bytes32);

    function addRemoteCaller(uint256 fromChain, bytes memory fromAddress, bool tag) external;

    function getExecutePermission(address mosAddress, uint256 fromChainId, bytes memory fromAddress) external view returns (bool);

    event mapMessageOut(uint256 indexed fromChain, uint256 indexed toChain, bytes32 orderId, bytes fromAddrss, bytes callData);

    event mapMessageIn(uint256 indexed fromChain, uint256 indexed toChain, bytes32 orderId, bytes fromAddrss, bytes callData, bool result, bytes reason);

}
