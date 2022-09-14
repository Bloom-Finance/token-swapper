# Token Swapper

Bloom's Token Swapper is a simple contract that allows users to swap between the same chain

For more information visit [Uniswap docs 🦄](https://docs.uniswap.org/)

### Supported tokens 💰

-   ETH
-   USDT
-   USDC
-   DAI

## Testing 🧪

All testing is done using [Goerli Testnet](https://goerli.etherscan.io/)

### Contract addresses for Goerli Testnet

| Tokens |                                  Addresses |
| ------ | -----------------------------------------: |
| DAI    | 0x11fE4B6AE13d2a6055C8D9cF65c55bac32B5d844 |
| USDT   | 0x509Ee0d083DdF8AC028f2a56731412edD63223B9 |
| USDC   | 0x2f3A40A3db8a7e3D09B0adfEfbCe4f6F81927557 |
| WETH   | 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6 |

### Contract addresses for ERC20 Mainnet

| Tokens |                                  Addresses |
| ------ | -----------------------------------------: |
| DAI    | 0x6B175474E89094C44Da98b954EedeAC495271d0F |
| USDT   | 0xdAC17F958D2ee523a2206206994597C13D831ec7 |
| USDC   | 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 |
| WETH   | 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2 |

### How to use 🤔

1.  Create your own .env file
2.  Add the specified keys to your .env file
3.  Run `yarn install` or `npm install`
4.  Run the following command to compile and deploy the contract:

```shell
npx hardhat compile
npm run deploy
```

### Environment variables 📝

| Item              |                         Value |
| ----------------- | ----------------------------: |
| RPC               |   Add your alchemy RPC server |
| ETHERSCAN_API_KEY | API Key provided by etherscan |
| PRIVATE_KEY       |       Your wallet private key |
