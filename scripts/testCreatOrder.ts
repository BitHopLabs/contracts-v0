import {ethers} from "hardhat";
import {genOrderId} from "./common";
import {BigNumber} from "ethers";
import {abi as TestCallAbi} from "../artifacts/contracts/test/TestCall.sol/TestCall.json";

async function main() {

    // dst chain
    const testCallContract = "0xb8eD16baa9e71d9EE85F30e83Cf1D226732aebDd"
    // src chain
    const mapRelayerContract = "0xA976496f9224A02965824275384A0B09A9d853f3"

    // src chain
    const endPoint = await ethers.getContractAt("EndPoint", "0x4c97aA9734f4ea54a58874889Df0a9d6f0589a53");
    console.log("endPoint " + endPoint.address);

    const signer = new ethers.Wallet("72dcee7bebb7554678b9c4000ce11a3f14000d588176c4f5b8af00657e113dc5");
    const orderId = genOrderId(80001, 97);
    console.log("orderId " + orderId);

    // logic
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

    const createParam = {
        relayer: mapRelayerContract,
        wallet: signer.address,
        orderId: orderId,
        signature: signMsg,
        feeParam: {
            feeToken: ethers.constants.AddressZero,
            amount: BigNumber.from("15000000000000000"),
            gasLimit: BigNumber.from(500000)
        },
        payParams: [{
            token: ethers.constants.AddressZero,
            amount: BigNumber.from(0)
        }],
        callParams: callParams
    };

    let tx = await endPoint.createOrder(createParam, {value: ethers.utils.parseEther("0.015")});
    console.log(tx)

    // const execParam = {
    //     wallet: signer.address,
    //     orderId: orderId,
    //     signature: signMsg,
    //     feeParam: {
    //         feeToken: ethers.constants.AddressZero,
    //         amount: BigNumber.from("15000000000000000"),
    //         gasLimit: BigNumber.from(500000)
    //     },
    //     payParams: [{
    //         token: ethers.constants.AddressZero,
    //         amount: BigNumber.from(0)
    //     }],
    //     callParams: callParams
    // }
    //
    // const mapRelayer = await ethers.getContractAt("MapRelayer", "0xC83544dA67CE2545211bc45c7B9AdF6174525956");
    // let tx = await mapRelayer.relay(97, execParam, {value: ethers.utils.parseEther("0.015")});
    // console.log(tx)
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});