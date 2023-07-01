// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../../interface/IKeeper.sol";
import "../AbstractAccount.sol";
import "./AAStorage.sol";
import "../../libraries/Decoded.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract Keeper is IKeeper, AAStorage {

    function execute(
        address eoa, uint orderId, bytes memory signature, CallParam[] memory callParams
    ) external override returns (bool) {
        (,uint dstChain, uint expTime) = Decoded.decodeOrderId(orderId);
        require(dstChain == block.chainid, "E0");
        require(expTime <= block.timestamp, "E0");

        bytes memory digest = abi.encode(eoa, orderId, callParams);
        for (uint i = 0; i < callParams.length; i++) {
        }
        return true;
    }

    function create(address eoa
    ) external returns (address) {
        address aa = address(new AbstractAccount(address(this)));
        require(owner[aa] == address(0), "E0");
        renewOwnership(eoa, aa);
        return aa;
    }


    function renewOwnership(
        address eoa,
        address aa
    ) internal {
        own[eoa] = aa;
        owner[aa] = eoa;
        emit renewOwner(eoa, aa);
    }
}
