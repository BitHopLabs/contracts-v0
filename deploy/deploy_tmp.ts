import {ethers} from "hardhat";
import {genOrderId} from "../scripts/common";
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
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
