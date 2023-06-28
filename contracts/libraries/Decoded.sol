// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

library Decoded {

    function verify(bytes calldata raw) external view returns (bytes memory payload) {
        (address eoa, uint orderId, bytes memory signature, bytes memory payload) = decodeRaw(raw);
        (,uint dstChain,uint expTime) = decodeOrderId(orderId);
        require(expTime < block.timestamp, "E0");
        require(dstChain == block.chainid, "E0");
        require(eoa == ECDSA.recover(keccak256(abi.encodePacked(
            orderId,
            payload
        )), signature), "E0");
        return payload;
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

    // eoa、orderId、signature、payload transferInfo
    function decodeRaw(bytes calldata raw) public pure returns (address eoa, uint orderId, bytes memory signature, bytes memory payload) {
        (eoa, orderId, signature, payload) = abi.decode(raw, (address, uint, bytes, bytes));
    }

    // size, len0, len1..., contract0、data0、contract1、data1...
    function decodePayload(bytes calldata payload) public pure returns (uint8 size, bytes[] memory callData){
        (uint8 size, uint16[] memory lens) = abi.decode(payload[: 352], (uint8, uint16[]));
        uint begin = 352;
        bytes[] memory callData = new bytes[](size);
        for (uint i = 0; i < size; i++) {
            callData[i] = payload[begin : begin + lens[i]];
            begin = begin + lens[i];
        }

        return (size, callData);
    }
}
