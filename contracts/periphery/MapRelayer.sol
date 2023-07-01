// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../interface/IRelayer.sol";
import "../interface/IMOSV3.sol";
import "../interface/IEndPoint.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MapRelayer is IRelayer, Ownable {

    mapping(uint => address) public endpoints;

    address public mos;

    constructor(address _mos) {
        mos = _mos;
    }

    function relay(uint dstChain, ExecParam memory execParam) external override returns (bool) {
        IMOSV3.MessageData memory mData = IMOSV3.MessageData(false, IMOSV3.MessageType.CALLDATA, abi.encodePacked(endpoints[dstChain]), abi.encodeWithSelector(IEndPoint.executeOrder.selector, execParam), execParam.feeParam.gasLimit, 0);

        (uint256 amount,) = IMOSV3(mos).getMessageFee(dstChain, address(0), execParam.feeParam.gasLimit);

        require(
            IMOSV3(mos).transferOut{value: amount}(
                dstChain,
                abi.encode(mData),
                execParam.feeParam.feeToken
            ),
            "send request failed"
        );

        return true;
    }

    function getMessageFee(uint256 _toChain, address _feeToken, uint256 _gasLimit) external view returns (uint256 amount, address notKnown) {
        (amount, notKnown) = IMOSV3(mos).getMessageFee(_toChain, _feeToken, _gasLimit);
    }

    function setMos(address _mos) external onlyOwner {
        mos = _mos;
    }
}
