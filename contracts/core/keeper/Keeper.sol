// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../../interface/IKeeper.sol";
import "../AbstractAccount.sol";
import "./AAStorage.sol";
import "../../libraries/Decoded.sol";

contract Keeper is IKeeper, AAStorage {

    function execute(
        address eoa, uint orderId, bytes memory signature, CallParam[] memory callParams
    ) external override returns (bool) {
        bytes memory digest = abi.encode(eoa, orderId, callParams);
        require(ECDSA.recover(digest, signature) == eoa, "E1");
        return true;
    }

    function create(
    ) external returns (address) {
        address newAA = address(new AbstractAccount(address(this)));
        require(owner[newAA] == address(0), "E0");
        renewOwnership(newAA, newAA);

        return newAA;
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
