// SPDX-License-Identifier: MIT
// OPT = 200

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

pragma solidity ^0.8.0;

contract BD3Vault {

    address BD3T = 0xb8eD16baa9e71d9EE85F30e83Cf1D226732aebDd;

    mapping(address => uint) public lockTime;
    mapping(address => uint) public lockAmount;
    mapping(address => address) public taskRel;

    function lockToken(uint256 amount, uint expireTime) public {
        IERC20(BD3T).transferFrom(msg.sender, address(this), amount);
        lockTime[msg.sender] = expireTime;
        lockAmount[msg.sender] = amount;
    }

    function assignTask(address receiver) public {
        taskRel[receiver] = msg.sender;
    }

    function redeem() public {
        require(lockTime[msg.sender] <= block.timestamp, "locked");
        IERC20(BD3T).transfer(msg.sender, lockAmount[msg.sender]);
    }

    function receiveAward() public {
        require(taskRel[msg.sender] != address(0), "rel fail");
        IERC20(BD3T).transfer(msg.sender, lockAmount[taskRel[msg.sender]]);
    }
}

