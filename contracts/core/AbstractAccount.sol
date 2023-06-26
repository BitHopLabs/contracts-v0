// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract AbstractAccount {



    receive() external payable {}

    fallback() external payable {}

    function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
