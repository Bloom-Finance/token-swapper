import {ethers, network, run} from "hardhat";
import {terminal} from "terminal-kit";
async function main() {
    const SwapFactory = await ethers.getContractFactory("BloomSwapper");
    const swap = await SwapFactory.deploy();
    const spinner = await terminal().spinner("dotSpinner");
    terminal().green(`  Deploying contract to ${network.name} 👨🏻‍🏭 \n`);
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
        terminal().brightBlue(`  Verifying contract on Etherscan 🕵🏻‍♂️ \n`);
        await verify(swap.address, []);
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
//TODO: Approve tokens task ...

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
