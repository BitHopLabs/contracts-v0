// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../libraries/TransferHelper.sol";
import "../libraries/Decoded.sol";
import "../interface/IRelayer.sol";
import "../interface/IEndPoint.sol";
import "../interface/IKeeper.sol";
import "../interface/IAbstractAccount.sol";
import "./keeper/AAStorage.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract EndPoint is IEndPoint, AAStorage {

    address public keeper;

    constructor(address _keeper) {
        keeper = _keeper;
    }

    mapping(uint => mapping(address => address)) public tokenMappings;

    function createOrder(CreateParam memory createParam) external payable {
        (uint srcChain,uint dstChain,) = Decoded.decodeOrderId(createParam.orderId);
        require(srcChain == block.chainid, "E0");

        TransferHelper.safeTransfer2(createParam.feeParam.feeToken, address(this), createParam.feeParam.amount);
        (uint feeAmount,) = IRelayer(createParam.relayer).getMessageFee(dstChain, address(0), 500000);
        require(createParam.feeParam.amount >= feeAmount, "E0");

        for (uint i = 0; i < createParam.payParams.length; i++) {
            TransferHelper.safeTransfer2(createParam.payParams[i].token, address(this), createParam.payParams[i].amount);
            if (createParam.payParams[i].token != address(0)) {
                address tokenOut = tokenMappings[dstChain][createParam.payParams[i].token];
                require(tokenOut != address(0), "E0");
                createParam.payParams[i].token = tokenOut;
            }
        }

        ExecParam memory execParam = ExecParam(createParam.wallet, createParam.orderId, createParam.signature, createParam.payParams, createParam.callParams);
        IRelayer(createParam.relayer).relay(dstChain, execParam);
    }

    function executeOrder(ExecParam memory execParam) external payable {
        address aa = own[execParam.wallet];
        if (aa == address(0)) {
            aa = IKeeper(keeper).create();
        }
        for (uint i = 0; i < execParam.payParams.length; i++) {
            TransferHelper.safeTransfer2(execParam.payParams[i].token, aa, execParam.payParams[i].amount);
        }

        IAbstractAccount(aa).execute(execParam.wallet, execParam.orderId, execParam.signature, execParam.callParams);
    }
}
