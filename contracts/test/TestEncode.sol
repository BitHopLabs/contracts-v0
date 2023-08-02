// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../libraries/TransferHelper.sol";
import "../libraries/Helper.sol";
import "@mapprotocol/mos/contracts/interface/IMOSV3.sol";

contract TestEncode {

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

    struct PayParam {
        address token;
        uint amount;
    }

    struct CallParam {
        address destination;
        bytes data;
    }

    struct FeeParam {
        address feeToken;
        uint amount;
        uint gasLimit;
    }

    function testEncode(bytes memory target, bytes memory payload, FeeParam calldata feeParam) external pure returns (bytes memory) {
        IMOSV3.MessageData memory mData = IMOSV3.MessageData(false, IMOSV3.MessageType.MESSAGE, target, payload, feeParam.gasLimit, 0);
        bytes memory ret = abi.encode(mData);
        return ret;
    }

    function testEncodeCreateParam(
        address wallet,
        uint orderId,
        bytes memory signature,
        FeeParam memory feeParam,
        PayParam[] memory payParams,
        CallParam[] memory callParams) external pure returns (bytes memory) {
        bytes memory payload = abi.encode(wallet, orderId, signature, feeParam, payParams, callParams);
        return payload;
    }

    function testDecode(bytes memory ret) external pure returns (bytes memory){
        IMOSV3.MessageData memory msgData = abi.decode(ret,(IMOSV3.MessageData));
       return msgData.payload;
    }

    function testDecodeCreateParam(bytes memory payload) external pure returns (bytes memory) {
        (address wallet,uint orderId,bytes memory signature,FeeParam memory feeParam,PayParam[] memory payParams,CallParam[] memory callParams) = abi.decode(payload, (address,uint,bytes,FeeParam, PayParam[], CallParam[]));
        return signature;
    }

    function test(bytes memory a, address b) external pure returns (address,bytes memory){
        address c = Helper._fromBytes(a);
        bytes memory d = Helper._toBytes(b);
        return (c,d);
    }
}
