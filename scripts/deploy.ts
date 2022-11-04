import {ethers, network, run} from "hardhat";
import signale from "signale";
import {terminal} from "terminal-kit";
async function main() {
    const _owners = ["0xF274800E82717D38d2e2ffe18A4C6489a50C5Add"];
    const currentNetworkId = network.config.chainId;
    signale.pending(`Deploying  contracts to ${network.name} \n`);
    const {_dai, _usdc, _usdt} = getContractsAddresses(currentNetworkId as any);
    //send array of owners
    const TreasureFactory = await ethers.getContractFactory("BloomTreasure");
    const treasure = await TreasureFactory.deploy(_owners, _dai, _usdc, _usdt);
    await treasure.deployed();
    signale.success(
        `Treasure contract was deployed to:${treasure.address} 🚀🚀 `
    );
    const SwapFactory = await ethers.getContractFactory("BloomSwapper");
    const swap = await SwapFactory.deploy(_dai, _usdc, _usdt, treasure.address);
    await swap.deployed();
    signale.success(`Swapper contract was deployed to:${swap.address} 🚀🚀 `);
    const TransferFactory = await ethers.getContractFactory("BloomTransfers");
    const transfer = await TransferFactory.deploy(
        _dai,
        _usdc,
        _usdt,
        treasure.address
    );
    await transfer.deployed();
    signale.success(
        `Transfers contract was deployed to:${transfer.address} 🚀🚀 `
    );
    if (
        (currentNetworkId === 5 ||
            currentNetworkId === 1 ||
            currentNetworkId === 137 ||
            currentNetworkId === 80001) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        signale.pending("Waiting for blocks to be mined 🕑 ");
        await swap.deployTransaction.wait(10);
        await treasure.deployTransaction.wait(10);
        await transfer.deployTransaction.wait(10);
        signale.success("Blocks mined ");
        signale.pending("Verifying  contracts on Etherscan");
        await verify(swap.address, [_dai, _usdc, _usdt, treasure.address]);
        await verify(treasure.address, [_owners, _dai, _usdc, _usdt]);
        await verify(transfer.address, [_dai, _usdc, _usdt, treasure.address]);
    }
}
async function verify(contractAddress: string, args: any[]) {
    try {
        await run("verify:verify", {
            address: contractAddress,
            constructorArguments: args,
        });
    } catch (error: any) {
        if (error.message.toLowerCase().includes("already verified")) {
            signale.complete("Contract already verified");
        }
    }
}
function getContractsAddresses(chainId: 1 | 5) {
    if (chainId === 5) {
        // goerli testnet
        return {
            _dai: "0x11fE4B6AE13d2a6055C8D9cF65c55bac32B5d844",
            _usdc: "0x07865c6E87B9F70255377e024ace6630C1Eaa37F",
            _usdt: "0x2DB274b9E5946855B83e9Eac5aA6Dcf2c68a95F3",
        };
    }
    if (chainId === 1) {
        // ethereum mainnet
        return {
            _dai: "0x6B175474E89094C44Da98b954EedeAC495271d0F",
            _usdc: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
            _usdt: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
        };
    }
    if (chainId === 80001) {
        //mumbai testnet
        return {
            _dai: "0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F",
            _usdc: "0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747",
            _usdt: "0xA02f6adc7926efeBBd59Fd43A84f4E0c0c91e832",
        };
    }
    if (chainId === 137) {
        //polygon mainnet
        return {
            _dai: "0x6B175474E89094C44Da98b954EedeAC495271d0F",
            _usdc: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
            _usdt: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
        };
    } else {
        throw new Error("Invalid chainId");
    }
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
