// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

library Decoded {

    function verify(address eoa, bytes32 digest, bytes calldata signature) external pure returns (bool) {
        bytes32 message = ECDSA.toEthSignedMessageHash(digest);
        return eoa == ECDSA.recover(message, signature);
    }

    function genOrderId(
        uint32 expTime, uint32 srcChainId, uint32 dstChainId
    ) public pure returns (uint orderId){
        orderId = (uint(expTime) << 64) + (uint(srcChainId) << 32) + uint(dstChainId);
    }

    function decodeOrderId(uint orderId) public pure returns (uint srcChain, uint dstChain, uint expTime) {
        dstChain = (orderId) & ((1 << 32) - 1);
        srcChain = (orderId >> 32) & ((1 << 32) - 1);
        expTime = (orderId >> 64) & ((1 << 32) - 1);
    }
}
