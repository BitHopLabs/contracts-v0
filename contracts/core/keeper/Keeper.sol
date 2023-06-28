// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../../interface/IKeeper.sol";
import "../AbstractAccount.sol";
import "./AAStorage.sol";
import "../../libraries/Decoded.sol";

contract Keeper is IKeeper, AAStorage {

    function execute(
        bytes calldata data
    ) external override returns (bool) {
        bytes memory payload = Decoded.verify(data);
        (uint8 size, bytes[] memory callData) = Decoded.decodePayload(payload);
        for (uint8 i = 0; i < size; i++) {

        }
        return true;
    }

    function create(
        bytes calldata data
    ) external {
        address newAA = address(new AbstractAccount(address(this)));
        require(owner[newAA] == address(0), "E0");
        renewOwnership(newAA, newAA);
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
