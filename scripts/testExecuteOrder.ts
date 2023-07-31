import {ethers} from "hardhat";
import {genOrderId} from "./common";
import {BigNumber} from "ethers";
import {abi as TestCallAbi} from "../artifacts/contracts/test/TestCall.sol/TestCall.json";

async function main() {

    const testCallContract = "0xb8eD16baa9e71d9EE85F30e83Cf1D226732aebDd"

    const endPoint = await ethers.getContractAt("EndPoint", "0x1D75c71a78cc5a260d1aa37AcfEb0e323504CB44");

    const signer = new ethers.Wallet("72dcee7bebb7554678b9c4000ce11a3f14000d588176c4f5b8af00657e113dc5");
    const orderId = genOrderId(212, 97);
    console.log("orderId " + orderId);


    let testCallInterface = new ethers.utils.Interface(TestCallAbi);
    let data = testCallInterface.encodeFunctionData("callFunction0", ["0", signer.address, ethers.constants.AddressZero]);
    console.log("data " + data)

    const callParams = [{
        destination: testCallContract,
        data: data
    }]
    console.log("callParams " + callParams)
    const encodeVal = ethers.utils.defaultAbiCoder.encode(['address', 'uint', 'tuple(address c, bytes d)[]'], [signer.address, orderId, [{
        c: testCallContract,
        d: data
    }]]);
    let msg = ethers.utils.solidityKeccak256(["bytes"], [encodeVal]);
    console.log("msg ", msg);
    const signMsg = await signer.signMessage(ethers.utils.arrayify(msg));
    console.log("signMsg ", signMsg);

    const execParam = {
        wallet: signer.address,
        orderId: orderId,
        signature: signMsg,
        feeParam: {
            feeToken: ethers.constants.AddressZero,
            amount: BigNumber.from("0"),
            gasLimit: BigNumber.from(500000)
        },
        payParams: [{
            token: ethers.constants.AddressZero,
            amount: BigNumber.from(0)
        }],
        callParams: callParams
    };
    let tx = await endPoint.executeOrder(execParam);
    const transactionReceipt = await tx.wait(1);
    console.log(transactionReceipt.logs)


}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
