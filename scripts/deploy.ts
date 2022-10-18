import {network, run} from "hardhat";
import {terminal} from "terminal-kit";
async function main() {
    const _owners = ["0xF274800E82717D38d2e2ffe18A4C6489a50C5Add"];
    const spinner = await terminal().spinner("dotSpinner");
    terminal().green(`  Deploying  contracts to ${network.name}  \n`);

    const {_dai, _usdc, _usdt} = getContractAddresses(
        network.config.chainId as any
    );
    //send array of owners
    const TreasureFactory = await ethers.getContractFactory("BloomTreasure");
    const treasure = await TreasureFactory.deploy(_owners, _dai, _usdc, _usdt);
    treasure.deployTransaction.wait();
    const SwapFactory = await ethers.getContractFactory("BloomSwapper");
    const swap = await SwapFactory.deploy(_dai, _usdc, _usdt, treasure.address);
    await swap.deployed();
    terminal("Swapper contract was deployed to: ").green.bold(
        `${swap.address} 🚀🚀 \n`
    );
    terminal("Treasure contract was deployed to: ").green.bold(
        `${treasure.address} 🚀🚀 \n`
    );
    spinner.animate(false);
    if (
        (network.config.chainId === 5 || network.config.chainId === 1) &&
        process.env.ETHERSCAN_API_KEY
    ) {
        let spinnerImpulse = await terminal().spinner("impulse");
        terminal().green(`  Waiting for blocks to be mined 🕑 \n`);
        await swap.deployTransaction.wait(5);
        spinnerImpulse.animate(false);
        let dotSpinner = await terminal().spinner("dotSpinner");
        terminal().brightBlue(`  Verifying  contracts on Etherscan  \n`);
        await verify(swap.address, [_dai, _usdc, _usdt, treasure.address]);
        await verify(treasure.address, [_owners, _dai, _usdc, _usdt]);
        dotSpinner.animate(false);
        terminal().yellow(
            `Swapper contract verified on Etherscan 🎉🎉. See it here: ${`https://${
                network.config.chainId === 5 ? "goerli." : ""
            }etherscan.io/address/${swap.address}#code`}\n`
        );
        terminal().yellow(
            `Treasure contract verified on Etherscan 🎉🎉. See it here: ${`https://${
                network.config.chainId === 5 ? "goerli." : ""
            }etherscan.io/address/${treasure.address}#code`}\n`
        );
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
            console.log("Contract already verified");
        }
    }
}
function getContractAddresses(chainId: 1 | 5) {
    if (chainId === 5) {
        return {
            _dai: "0x11fE4B6AE13d2a6055C8D9cF65c55bac32B5d844",
            _usdc: "0x07865c6E87B9F70255377e024ace6630C1Eaa37F",
            _usdt: "0x2DB274b9E5946855B83e9Eac5aA6Dcf2c68a95F3",
        };
    }
    if (chainId === 1) {
        return {
            _dai: "0x6B175474E89094C44Da98b954EedeAC495271d0F",
            _usdc: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
            _usdt: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
        };
    } else {
        throw new Error("Invalid chainId");
    }
}

//TODO: Approve tokens task ...

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
