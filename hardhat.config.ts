import {HardhatUserConfig} from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import dotenv from 'dotenv';

dotenv.config();

const PRI_KEY = process.env.PRI_KEY;

const config: HardhatUserConfig = {
    networks: {
        hardhat: {},
        opTestnet: {
            url: 'https://goerli.optimism.io',
        },
        bscTestnet: {
            url: 'https://bsc-testnet.public.blastapi.io',
            gas: 2000000,
            accounts: [`${PRI_KEY}`]
        },
        op: {
            url: 'https://alien-tame-firefly.optimism.discover.quiknode.pro/e406d1013fbe696428f4ae9e77a5a2f48d1426ac/',
        },
        avax: {
            url: `https://small-palpable-reel.avalanche-mainnet.quiknode.pro/2aa28554a63480222471f355354defe5a5bef17d/ext/bc/C/rpc`,
        },
        bsc: {
            url: 'https://burned-clean-crater.bsc.quiknode.pro/5cacde470dbfb4087eab934b54e6b05fc59e1e92/',
        },
        arbGoerli: {
            url: 'https://goerli-rollup.arbitrum.io/rpc',
        },
        polygon: {
            url: 'https://rpc.ankr.com/polygon/12c187efd7ef6e437a404f3b56cd2ef24daeb506b3afc9c9691d75afc98b7183',
        },
        mumbai: {
            url: 'https://rpc.ankr.com/polygon_mumbai',
            gas: 10000000,
            accounts: [`${PRI_KEY}`]
        },
    },
    solidity: {
        version: "0.8.17",
        settings: {
            optimizer: {
                enabled: true,
                runs: 200,
            },
        },
    },
};

export default config;
