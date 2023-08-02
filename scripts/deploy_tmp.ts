import {ethers} from "hardhat";
import {genOrderId} from "./common";
import {BigNumber} from "ethers";
import {abi as TestCallAbi} from "../artifacts/contracts/test/TestCall.sol/TestCall.json";

async function main() {

    const iMapoExecutor = await ethers.getContractAt("IMapoExecutor", "0x09a53D20F17A5eacbaDF7b3Fc8B0e9B13A4a7FFe");
    const tx = await iMapoExecutor.mapoExecute(212,97,"0x6f66A7bDeBF0aB4df345fc5f12384072e5Aab620","0x5f8a85001acc8034c3d57a61d36b33f0fea100774e2af96a16e94d3f1f7da4a3","0x6f66A7bDeBF0aB4df345fc5f12384072e5Aab620");
    console.log(tx)
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
