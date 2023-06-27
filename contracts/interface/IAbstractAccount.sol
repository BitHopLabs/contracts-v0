// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IAbstractAccount {

    function keeper() external returns (address);

    function execute(
        bytes calldata data
    ) external returns (bool res);
}
