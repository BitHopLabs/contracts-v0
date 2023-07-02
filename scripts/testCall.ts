import {ethers} from "hardhat";
import {genOrderId} from "./common";
import {BigNumber} from "ethers";
import {abi as TestCallAbi} from "../artifacts/contracts/test/TestCall.sol/TestCall.json";

async function main() {

    const mosBSCTestnet = "0x8C3cCc219721B206DA4A2070fD96E4911a48CB4f";

    const Keeper = await ethers.getContractFactory("Keeper");
    const keeper = await Keeper.deploy();
    await keeper.deployed();
    console.log(keeper.address);

    const MapRelayer = await ethers.getContractFactory("MapRelayer");
    const mapRelayer = await MapRelayer.deploy(mosBSCTestnet);
    await mapRelayer.deployed();
    console.log(mapRelayer.address);

    const EndPoint = await ethers.getContractFactory("EndPoint");
    const endPoint = await EndPoint.deploy(keeper.address, mapRelayer.address);
    await endPoint.deployed();
    console.log(endPoint.address);

    const TestCall = await ethers.getContractFactory("TestCall");
    const testCall = await TestCall.deploy();
    await testCall.deployed();
    console.log(testCall.address);

    const signer = new ethers.Wallet("72dcee7bebb7554678b9c4000ce11a3f14000d588176c4f5b8af00657e113dc5");
    const orderId = genOrderId(97, 43117);


    let testCallInterface = new ethers.utils.Interface(TestCallAbi);
    let data = testCallInterface.encodeFunctionData("callFunction0", ["0", signer.address, ethers.constants.AddressZero]);

    const callParams = [{
        destination: testCall.address,
        data: data
    }]
    const msg = ethers.utils.keccak256(ethers.utils.defaultAbiCoder.encode(['address', 'uint', 'address', 'bytes'], [signer.address, orderId, testCall.address, data]));
    const signMsg = await signer.signMessage(msg);


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
    await endPoint.executeOrder(execParam);


}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
