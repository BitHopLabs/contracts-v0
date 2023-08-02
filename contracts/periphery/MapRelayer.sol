// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../interface/IRelayer.sol";
import "../libraries/TransferHelper.sol";
import "../libraries/Helper.sol";
import "@mapprotocol/mos/contracts/interface/IMOSV3.sol";
import "@mapprotocol/mos/contracts/interface/IMapoExecutor.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MapRelayer is IRelayer, Ownable {

    mapping(uint => address) public endpoints;

    address public mos;

    constructor(address _mos) {
        mos = _mos;
    }

    function relay(uint dstChain, bytes memory payload, FeeParam calldata feeParam) external payable override {
        bytes memory target = Helper._toBytes(endpoints[dstChain]);
        IMOSV3.MessageData memory mData = IMOSV3.MessageData(false, IMOSV3.MessageType.MESSAGE, target, payload, feeParam.gasLimit, 0);

        (uint256 amount,) = IMOSV3(mos).getMessageFee(dstChain, address(0), feeParam.gasLimit);

        bytes32 orderId = IMOSV3(mos).transferOut{value: amount}(
            dstChain,
            abi.encode(mData),
            feeParam.feeToken
        );
        emit bridgeOrder(orderId, payload);
    }

    function getMessageFee(uint256 _toChain, address _feeToken, uint256 _gasLimit) external view returns (uint256 amount, address notKnown) {
        (amount, notKnown) = IMOSV3(mos).getMessageFee(_toChain, _feeToken, _gasLimit);
    }

    function setMos(address _mos) external onlyOwner {
        mos = _mos;
    }

    function setEndpoint(uint dstChain, address endpoint) external onlyOwner {
        endpoints[dstChain] = endpoint;
    }
}
