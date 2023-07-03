import {ethers} from "hardhat";
import {genOrderId} from "./common";
import {BigNumber} from "ethers";
import {abi as TestCallAbi} from "../artifacts/contracts/test/TestCall.sol/TestCall.json";

async function main() {

    const mosBSCTestnet = "0x8C3cCc219721B206DA4A2070fD96E4911a48CB4f";

    const Decoded = await ethers.getContractFactory("Decoded");
    const decoded = await Decoded.deploy();
    await decoded.deployed();
    console.log(decoded.address);

    const Keeper = await ethers.getContractFactory("Keeper", {
        libraries: {
            Decoded: decoded.address,
        },
    });
    const keeper = await Keeper.deploy();
    await keeper.deployed();
    console.log(keeper.address);

    const MapRelayer = await ethers.getContractFactory("MapRelayer");
    const mapRelayer = await MapRelayer.deploy(mosBSCTestnet);
    await mapRelayer.deployed();
    console.log(mapRelayer.address);

    const EndPoint = await ethers.getContractFactory("EndPoint", {
        libraries: {
            Decoded: decoded.address,
        },
    });
    const endPoint = await EndPoint.deploy(keeper.address);
    await endPoint.deployed();
    console.log(endPoint.address);

    const TestCall = await ethers.getContractFactory("TestCall");
    const testCall = await TestCall.deploy();
    await testCall.deployed();
    console.log(testCall.address);

    const signer = new ethers.Wallet("72dcee7bebb7554678b9c4000ce11a3f14000d588176c4f5b8af00657e113dc5");
    const orderId = genOrderId(97, 31337);
    console.log(orderId);


    let testCallInterface = new ethers.utils.Interface(TestCallAbi);
    let data = testCallInterface.encodeFunctionData("callFunction0", ["0", signer.address, ethers.constants.AddressZero]);

    const callParams = [{
        destination: testCall.address,
        data: data
    }]
    const encodeVal = ethers.utils.defaultAbiCoder.encode(['address', 'uint', 'tuple(address c, bytes d)[]'], [signer.address, orderId, [{
        c: testCall.address,
        d: data
    }]]);
    let msg = ethers.utils.solidityKeccak256(["bytes"],[encodeVal]);
    console.log("msg ", msg);
    console.log("signer ", signer.address);
    const signMsg = await signer.signMessage(ethers.utils.arrayify(msg));
    console.log("signMsg ", signMsg);
    const verifyAddr = ethers.utils.verifyMessage(msg, signMsg);
    const recoverAddr = ethers.utils.recoverAddress(msg, signMsg);
    console.log(verifyAddr);
    console.log(recoverAddr);

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
