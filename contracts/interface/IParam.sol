// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IParam {

    event OrderCreated(
        bytes indexed createParam
    );

    event MapExecuted(
        bytes indexed execParam
    );

    event DestinationCall(
        CallParam[] indexed params
    );

    struct CreateParam {
        address relayer;
        address wallet;
        uint orderId;
        bytes signature;
        FeeParam feeParam;
        PayParam[] payParams;
        CallParam[] callParams;
    }

    struct MapParam {
        uint256 fromChain;
        uint256 dstChain;
        bytes fromAddress;
        bytes32 orderId;
        bytes execParam;
    }

    struct ExecParam {
        address wallet;
        uint orderId;
        bytes signature;
        FeeParam feeParam;
        PayParam[] payParams;
        CallParam[] callParams;
    }

    struct FeeParam {
        address feeToken;
        uint amount;
        uint256 gasLimit;
    }

    struct PayParam {
        address token;
        uint amount;
    }

    struct CallParam {
        address destination;
        bytes data;
    }
}
