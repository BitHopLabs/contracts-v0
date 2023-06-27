// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IKeeper {

    event renewOwner(
        address indexed eoa,
        address indexed aa
    );

    function execute(
        bytes calldata data
    ) external returns (bool res);

    function create(
        bytes calldata data
    ) external;
}
