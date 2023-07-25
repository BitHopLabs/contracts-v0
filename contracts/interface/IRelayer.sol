// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IParam.sol";

interface IRelayer is IParam {

    event bridgeOrder(
        bytes32 indexed orderId
    );

    function getMessageFee(uint256 _toChain, address _feeToken, uint256 _gasLimit) external view returns (uint256, address);

    function relay(uint dstChain, ExecParam memory execParam) payable external;
}
