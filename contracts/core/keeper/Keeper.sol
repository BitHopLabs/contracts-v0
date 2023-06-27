// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../../interface/IKeeper.sol";
import "../AbstractAccount.sol";
import "./AAStorage.sol";

contract Keeper is IKeeper, AAStorage {

    function execute(
        bytes calldata data
    ) external override returns (bool) {
        require(verify(data), "E0");
        return true;
    }

    function create(
        bytes calldata data
    ) external {
        address newAA = address(new AbstractAccount(address(this)));
        require(verify(data), "E0");
        require(owner[newAA] == address(0), "E0");
        renewOwnership(newAA, newAA);
    }

    function verify(
        bytes calldata data
    ) internal returns (bool) {
        return true;
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
