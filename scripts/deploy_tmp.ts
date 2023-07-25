import {ethers} from "hardhat";
import {genOrderId} from "./common";
import {BigNumber} from "ethers";
import {abi as TestCallAbi} from "../artifacts/contracts/test/TestCall.sol/TestCall.json";

async function main() {

    const EndPoint = await ethers.getContractFactory("EndPoint", {
        libraries: {
            Decoded: "0x7651A9D3b8dF67607d31e1d34e3056746b3A3AaC",
        },
    });
    const endPoint = await EndPoint.deploy("0x3C076204Ee78C761BBE00d6461A388b467A4b9C8");
    await endPoint.deployed();
    console.log("endPoint " + endPoint.address);

    const MapRelayer = await ethers.getContractFactory("MapRelayer");
    const mapRelayer = await MapRelayer.deploy("0x8C3cCc219721B206DA4A2070fD96E4911a48CB4f");
    await mapRelayer.deployed();
    await mapRelayer.setEndpoint(97, "0x1D75c71a78cc5a260d1aa37AcfEb0e323504CB44");
    console.log("mapRelayer " + mapRelayer.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
