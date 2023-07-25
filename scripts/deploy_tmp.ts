import {ethers} from "hardhat";
import {genOrderId} from "./common";
import {BigNumber} from "ethers";
import {abi as TestCallAbi} from "../artifacts/contracts/test/TestCall.sol/TestCall.json";

async function main() {

    const Decoded = await ethers.getContractFactory("Decoded");
    const decoded = await Decoded.deploy();
    await decoded.deployed();
    console.log("decoded " + decoded.address);

    const EndPoint = await ethers.getContractFactory("EndPoint", {
        libraries: {
            Decoded: decoded.address,
        },
    });
    const endPoint = await EndPoint.deploy("0x3C076204Ee78C761BBE00d6461A388b467A4b9C8");
    await endPoint.deployed();
    console.log("endPoint " + endPoint.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
