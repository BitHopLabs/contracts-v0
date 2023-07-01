// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IParam {

    event OrderCreated(
        CreateParam indexed createParam
    );

    event OrderExecuted(
        ExecParam indexed execParam
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
        uint gasLimit;
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
