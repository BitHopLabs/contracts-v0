// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

interface IAAStorage {

    function own(address eoa) external view returns(address);
    function owner(address aa) external view returns(address);
}
