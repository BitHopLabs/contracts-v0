import {ethers} from "hardhat";
import {genOrderId} from "./common";
import {BigNumber} from "ethers";
import {abi as TestCallAbi} from "../artifacts/contracts/test/TestCall.sol/TestCall.json";
import {mos} from "../typechain-types/@mapprotocol";

async function main() {

    const mos = "0x8C3cCc219721B206DA4A2070fD96E4911a48CB4f";
    const decoded = "0x54Af2FE830A16635c6A64E5A97604902E6e7c58A";
    const keeper = "0x51a180ee4Dc6Dfd77ac180DbF30b303f87c35F22";

    const EndPoint = await ethers.getContractFactory("EndPoint", {
        libraries: {
            Decoded: decoded,
        },
    });
    const endPoint = await EndPoint.deploy(keeper, mos);
    await endPoint.deployed();
    console.log("endPoint " + endPoint.address);

    const MapRelayer = await ethers.getContractFactory("MapRelayer");
    const mapRelayer = await MapRelayer.deploy(mos);
    await mapRelayer.deployed();
    console.log("mapRelayer " + mapRelayer.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
