import {ethers} from "hardhat";
import {genOrderId} from "../scripts/common";
import {BigNumber} from "ethers";
import {abi as TestCallAbi} from "../artifacts/contracts/test/TestCall.sol/TestCall.json";
import {mos} from "../typechain-types/@mapprotocol";

async function main() {

    const mos = "0x8C3cCc219721B206DA4A2070fD96E4911a48CB4f";

    // bsc
    // const decoded = "0xc4Ac28584Ca9E9A19CCBEadFf6faDfCAE05Fe087";
    // const keeper = "0xa60860aCD850A22F19C125517a24c92cc8c61074";

    // map
    // const decoded = "0x54Af2FE830A16635c6A64E5A97604902E6e7c58A";
    // const keeper = "0x51a180ee4Dc6Dfd77ac180DbF30b303f87c35F22";

    // polygon
    const decoded = "0x1C130D59086c2771A4E2Aed3cF99f9AB65446A8b";
    const keeper = "0xdB1bedaca1Ae4e36A8708387b14e10138596E3A4";

    const FakeToken = await ethers.getContractFactory("FakeToken");
    const fakeToken = await FakeToken.deploy("USDSMAIN", "USDSMAIN", 18);
    await fakeToken.deployed();
    console.log("fakeToken " + fakeToken.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
