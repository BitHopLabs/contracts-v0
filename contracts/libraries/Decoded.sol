// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

library Decoded {

    function verify(address eoa, uint orderId, bytes calldata payload, bytes calldata signature) external pure {
        bytes32 digest = keccak256(abi.encodePacked(
            orderId,
            payload
        ));
        require(eoa == ECDSA.recover(digest, signature), "E1");
    }

    function genOrderId(
        uint128 nonce, uint32 expTime, uint32 srcChainId, uint32 dstChainId
    ) public pure returns (uint orderId){
        orderId = (uint(nonce) << 96) + (uint(expTime) << 64) + (uint(srcChainId) << 32) + uint(dstChainId);
    }

    function decodeOrderId(uint orderId) public pure returns (uint srcChain, uint dstChain, uint expTime) {
        dstChain = (orderId) & ((1 << 32) - 1);
        srcChain = (orderId >> 32) & ((1 << 32) - 1);
        expTime = (orderId >> 64) & ((1 << 32) - 1);
    }

    // eoa、orderId、signature、payload
    function decodeRaw(bytes calldata raw) public pure returns (address eoa, uint orderId, bytes memory signature, bytes memory payload) {
        (eoa, orderId, signature, payload) = abi.decode(raw, (address, uint, bytes, bytes));
    }

    // size, len0, len1..., contract0、data0、contract1、data1...
    function decodePayload(bytes calldata payload) public pure returns (bytes[] memory callData){
        (uint8 size, uint16[] memory lens) = abi.decode(payload[: 352], (uint8, uint16[]));
        uint begin = 352;
        bytes[] memory callData = new bytes[](size);
        for (uint i = 0; i < size; i++) {
            callData[i] = payload[begin : begin + lens[i]];
            begin = begin + lens[i];
        }

        return callData;
    }
}
