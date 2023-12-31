// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "../libraries/TransferHelper.sol";
import "../libraries/Helper.sol";
import "../libraries/Decoded.sol";
import "../interface/IRelayer.sol";
import "../interface/IEndPoint.sol";
import "../interface/IKeeper.sol";
import "../interface/IAbstractAccount.sol";
import "../interface/IAAStorage.sol";
import "./keeper/Keeper.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@mapprotocol/mos/contracts/interface/IMapoExecutor.sol";

contract EndPoint is IEndPoint, Ownable, IMapoExecutor {

    mapping(uint => mapping(address => address)) public tokenMappings;

    address public keeper;
    address public mos;

    constructor(address _keeper, address _mos) {
        keeper = _keeper;
        mos = _mos;
    }

    function createOrder(CreateParam memory createParam) external payable {
        (uint srcChain,uint dstChain,) = Decoded.decodeOrderId(createParam.orderId);
        require(srcChain == block.chainid, "E3");

        (uint feeAmount,) = IRelayer(createParam.relayer).getMessageFee(dstChain, createParam.feeParam.feeToken, createParam.feeParam.gasLimit);
        uint depositEthFee;
        if (createParam.feeParam.feeToken != address(0)) {
            require(createParam.feeParam.amount >= feeAmount, "E4");
            SafeERC20.safeTransferFrom(
                IERC20(createParam.feeParam.feeToken),
                msg.sender,
                address(this),
                createParam.feeParam.amount
            );
        } else {
            require(msg.value >= feeAmount, "E4");
            depositEthFee += feeAmount;
        }

        for (uint i = 0; i < createParam.payParams.length; i++) {
            if (createParam.payParams[i].amount > 0) {
                if (createParam.payParams[i].token != address(0)) {
                    SafeERC20.safeTransferFrom(
                        IERC20(createParam.payParams[i].token),
                        msg.sender,
                        address(this),
                        createParam.payParams[i].amount
                    );
                } else {
                    require(msg.value >= createParam.payParams[i].amount, "E4");
                    depositEthFee += createParam.payParams[i].amount;
                }
                if (createParam.payParams[i].token != address(0)) {
                    address tokenOut = tokenMappings[dstChain][createParam.payParams[i].token];
                    require(tokenOut != address(0), "E5");
                    createParam.payParams[i].token = tokenOut;
                }
            }
        }

        require(msg.value >= depositEthFee, "E41");

        bytes memory payload = abi.encode(createParam.wallet, createParam.orderId, createParam.signature, createParam.feeParam, createParam.payParams, createParam.callParams);
        IRelayer(createParam.relayer).relay{value: msg.value}(dstChain, payload, createParam.feeParam);
        emit OrderCreated(
            payload
        );
    }

    function mapoExecute(
        uint256 _fromChain,
        uint256 _toChain,
        bytes calldata _fromAddress,
        bytes32 _orderId,
        bytes calldata _message
    ) external override returns (bytes memory newMessage){
        require(_msgSender() == address(mos), "MapoExecutor: invalid mos caller");
        require(_toChain == block.chainid, "E31");
        (address wallet,uint orderId,bytes memory signature,FeeParam memory feeParam,PayParam[] memory payParams,CallParam[] memory callParams) = abi.decode(_message, (address, uint, bytes, FeeParam, PayParam[], CallParam[]));
        emit MapExecuted(
            _message
        );
        ExecParam memory execParam = ExecParam(wallet, orderId, signature, feeParam, payParams, callParams);
        _execute(execParam);
        return _message;
    }

    function _execute(
        ExecParam memory execParam) internal {
        address aa = Keeper(keeper).own(execParam.wallet);
        if (aa == address(0)) {
            aa = IKeeper(keeper).create(execParam.wallet, execParam.orderId, execParam.signature, execParam.callParams);
        }
        for (uint i = 0; i < execParam.payParams.length; i++) {
            if (execParam.payParams[i].amount > 0) {
                Helper._transfer(execParam.payParams[i].token, aa, execParam.payParams[i].amount);
            }
        }

        IAbstractAccount(aa).execute(execParam.wallet, execParam.orderId, execParam.signature, execParam.callParams);
    }

    function setKeeper(address _keeper) external onlyOwner {
        keeper = _keeper;
    }

    function setTokenMappings(uint dstChain, address srcToken, address dstToken) external onlyOwner {
        tokenMappings[dstChain][srcToken] = dstToken;
    }

    receive() external payable {}

    fallback() external payable {}
}
