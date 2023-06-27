// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../../interface/IAAStorage.sol";

abstract contract AAStorage is IAAStorage {
    mapping(address => mapping(uint => uint)) public status;
    mapping(address => address) public own;
    mapping(address => address) public owner;
}
