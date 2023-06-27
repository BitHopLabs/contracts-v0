// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interface/IKeeper.sol";
import "../interface/IAbstractAccount.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract AbstractAccount is IAbstractAccount {

    address public override keeper;

    constructor (address keeper_){
        keeper = keeper_;
    }

    function execute(
        bytes calldata data
    ) external override returns (bool res){
        res = IKeeper(keeper).execute(data);
    }

    receive() external payable {}

    fallback() external payable {}

    function onERC721Received(address, address, uint256, bytes calldata) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }
}
