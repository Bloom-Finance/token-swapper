import {ethers, network, run} from "hardhat";
import {terminal} from "terminal-kit";
async function main() {
    const SwapFactory = await ethers.getContractFactory("BloomSwapper");
    const {_dai, _usdc, _usdt, _weth} = getContractAddresses(
        network.config.chainId as any
    );
    const swap = await SwapFactory.deploy(_dai, _usdc, _usdt, _weth);
    const spinner = await terminal().spinner("dotSpinner");
    terminal().green(`  Deploying contract to ${network.name}  \n`);
    await swap.deployed();
    terminal("Your contract was deployed to: ").green.bold(
        `${swap.address} 🚀🚀 \n`
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
        terminal().brightBlue(`  Verifying contract on Etherscan  \n`);
        await verify(swap.address, [_dai, _usdc, _usdt, _weth]);
        dotSpinner.animate(false);
        terminal().yellow(
            `Contract verified on Etherscan 🎉🎉. See it here: ${`https://goerli.etherscan.io/address/${swap.address}#code`}\n`
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
            _usdc: "0x07865c6e87b9f70255377e024ace6630c1eaa37f",
            _usdt: "0x509Ee0d083DdF8AC028f2a56731412edD63223B9",
            _weth: "0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6",
        };
    }
    if (chainId === 1) {
        return {
            _dai: "0x6B175474E89094C44Da98b954EedeAC495271d0F",
            _usdc: "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48",
            _usdt: "0xdAC17F958D2ee523a2206206994597C13D831ec7",
            _weth: "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2",
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
