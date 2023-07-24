// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IParam.sol";

interface IEndPoint is IParam {

    function createOrder(CreateParam memory createParam) external payable;

    function executeOrder(ExecParam memory execParam) external payable;
}
