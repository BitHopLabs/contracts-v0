import {ethers} from "hardhat";
import {genOrderId} from "./common";
import {BigNumber} from "ethers";
import {abi as TestCallAbi} from "../artifacts/contracts/test/TestCall.sol/TestCall.json";
import {mos} from "../typechain-types/@mapprotocol";

async function main() {

    const mos = "0x8C3cCc219721B206DA4A2070fD96E4911a48CB4f";

    // bscTestnet
    const decoded = "0xc4Ac28584Ca9E9A19CCBEadFf6faDfCAE05Fe087";
    const keeper = "0xa60860aCD850A22F19C125517a24c92cc8c61074";

    // makalu
    // const decoded = "0x54Af2FE830A16635c6A64E5A97604902E6e7c58A";
    // const keeper = "0x51a180ee4Dc6Dfd77ac180DbF30b303f87c35F22";

    // mumbai
    // const decoded = "0x7651A9D3b8dF67607d31e1d34e3056746b3A3AaC";
    // const keeper = "0x3C076204Ee78C761BBE00d6461A388b467A4b9C8";

    const EndPoint = await ethers.getContractFactory("EndPoint", {
        libraries: {
            Decoded: decoded,
        },
    });
    const endPoint = await EndPoint.deploy(keeper, mos);
    await endPoint.deployed();
    console.log("endPoint " + endPoint.address);

    // const MapRelayer = await ethers.getContractFactory("MapRelayer");
    // const mapRelayer = await MapRelayer.deploy(mos);
    // await mapRelayer.deployed();
    // await mapRelayer.setEndpoint(97, "0x819Ee5bff83ACA8BbBBb5e3f477E1BDA41879134");
    // console.log("mapRelayer " + mapRelayer.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
