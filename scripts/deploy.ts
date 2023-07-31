import {ethers} from "hardhat";
import {genOrderId} from "./common";
import {BigNumber} from "ethers";
import {abi as TestCallAbi} from "../artifacts/contracts/test/TestCall.sol/TestCall.json";

async function main() {

    const mosTestnet = "0x8C3cCc219721B206DA4A2070fD96E4911a48CB4f";

    const Decoded = await ethers.getContractFactory("Decoded");
    const decoded = await Decoded.deploy();
    await decoded.deployed();
    console.log("decoded " + decoded.address);

    const Keeper = await ethers.getContractFactory("Keeper", {
        libraries: {
            Decoded: decoded.address,
        },
    });
    const keeper = await Keeper.deploy();
    await keeper.deployed();
    console.log("keeper " + keeper.address);

    const EndPoint = await ethers.getContractFactory("EndPoint", {
        libraries: {
            Decoded: decoded.address,
        },
    });
    const endPoint = await EndPoint.deploy(keeper.address);
    await endPoint.deployed();
    console.log("endPoint " + endPoint.address);

    const MapRelayer = await ethers.getContractFactory("MapRelayer");
    const mapRelayer = await MapRelayer.deploy(mosTestnet);
    await mapRelayer.deployed();
    await mapRelayer.setEndpoint(80001, "0x4146CD8323b4A3e8D30926f6e6fA5E297AB10A22");
    await mapRelayer.setEndpoint(97, "0x1D75c71a78cc5a260d1aa37AcfEb0e323504CB44");
    console.log("mapRelayer " + mapRelayer.address);

    const TestCall = await ethers.getContractFactory("TestCall");
    const testCall = await TestCall.deploy();
    await testCall.deployed();
    console.log("testCall " + testCall.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
