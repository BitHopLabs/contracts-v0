// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IParam.sol";

interface IAbstractAccount is IParam {

    function keeper() external returns (address);

    function execute(
        address eoa, uint orderId, bytes memory signature, CallParam[] memory callParams
    ) external;
}
