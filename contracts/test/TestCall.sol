// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract TestCall {

    event CallHandle(
        string indexed param0,
        address indexed param1,
        address indexed param2
    );

    function callFunction0(string calldata param0, address param1, address param2) external {
        emit CallHandle(param0, param1, param2);
    }

    function callFunction1(string calldata param0, address param1, address param2) external {
        emit CallHandle(param0, param1, param2);
    }
}
