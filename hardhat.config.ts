import {HardhatUserConfig} from "hardhat/config";
import "hardhat-gas-reporter";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-etherscan";
import * as dotenv from "dotenv";
dotenv.config({path: __dirname + "/.env"});
const config: HardhatUserConfig = {
    solidity: "0.8.9",
    networks: {
        goerli: {
            url: process.env.RPC_GOERLI,
            accounts: [process.env.PRIVATE_KEY as string],
            chainId: 5,
        },
        mainnet: {
            url: process.env.RPC_MAINNET,
            accounts: [process.env.PRIVATE_KEY as string],
            chainId: 1,
        },
    },
    etherscan: {
        apiKey: process.env.ETHERSCAN_API_KEY as string,
    },
    gasReporter: {
        enabled: true,
        coinmarketcap: process.env.COINMARKETCAP_API_KEY,
        outputFile: "gas-report.txt",
        currency: "USD",
        token: "ETH",
        noColors: true,
    },
};

export default config;
