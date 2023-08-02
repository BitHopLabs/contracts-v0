
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../libraries/Helper.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TestTransfer {

    function testHelperTransfer(address token, uint amount) external {
        Helper._transfer(token, address(this), amount);
    }

    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function testTransfer(address token, uint amount) external {
        IERC20(token).transfer(address(this), amount);
    }

    function testSender() external view returns (address) {
        return _msgSender();
    }
}
