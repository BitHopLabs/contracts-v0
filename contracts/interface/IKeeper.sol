// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interface/IAAStorage.sol";
import "./IParam.sol";

interface IKeeper is IParam {

    event renewOwner(
        address indexed eoa,
        address indexed aa
    );

    function execute(
        address eoa, uint orderId, bytes memory signature, CallParam[] memory callParams
    ) external returns (bool res);

    function create(address eoa) external returns (address);
}
