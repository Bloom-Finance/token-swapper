# Token Swapper

Bloom's Token Swapper is a simple contract that allows users to swap between the same chain

For more information visit [Uniswap docs 🦄](https://docs.uniswap.org/)

### Supported tokens 💰

-   ETH
-   MATIC
-   USDT
-   USDC
-   DAI

## Testing 🧪

All testing is done using [Goerli Testnet 🔗](https://goerli.etherscan.io/)

### Last stable testnet contracts for GOERLI ⚙️

-   [SWAPPER 🔄](https://goerli.etherscan.io/address/0x63676f1Aaad4C5a9443Fb3bd1FEF6611F6A5E84E): 0x63676f1Aaad4C5a9443Fb3bd1FEF6611F6A5E84E
-   [TREASURE 🤑](https://goerli.etherscan.io/address/0x0CDc2A86A61935E4AB920054Fd204a6bB713BDC4): 0x0CDc2A86A61935E4AB920054Fd204a6bB713BDC4
-   [TRANSFERS 💸](https://goerli.etherscan.io/address/0xAc45bA539d2f01995A266475D6526395353d4357): 0xAc45bA539d2f01995A266475D6526395353d4357

### Last stable testnet contracts for MUMBAI 🟣

-   [SWAPPER 🔄](https://mumbai.polygonscan.com/address/0x282f2593c1C7425C6bd582fb2AFEeA056f78f75B): 0x282f2593c1C7425C6bd582fb2AFEeA056f78f75B
-   [TREASURE 🤑](https://mumbai.polygonscan.com/address/0x130612d9359b9a51adf9bc4289c610782904bad1): 0x130612D9359b9A51adf9bC4289c610782904BAD1
-   [TRANSFERS 💸](https://mumbai.polygonscan.com/address/0xAfDa87fb56C155be167eD088cD54A3e70A5dEC73): 0xAfDa87fb56C155be167eD088cD54A3e70A5dEC73

## Ethereum 🌎

### Contract addresses for Goerli Testnet

| Tokens |                                  Addresses |
| ------ | -----------------------------------------: |
| DAI    | 0x11fE4B6AE13d2a6055C8D9cF65c55bac32B5d844 |
| USDT   | 0x2DB274b9E5946855B83e9Eac5aA6Dcf2c68a95F3 |
| USDC   | 0x07865c6E87B9F70255377e024ace6630C1Eaa37F |

### Contract addresses for ERC20 Mainnet

| Tokens |                                  Addresses |
| ------ | -----------------------------------------: |
| DAI    | 0x6B175474E89094C44Da98b954EedeAC495271d0F |
| USDT   | 0xdAC17F958D2ee523a2206206994597C13D831ec7 |
| USDC   | 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 |

## Polygon 🔮

### Tokens contracts addresses for Mumbai Testnet

| Tokens |                                  Addresses |
| ------ | -----------------------------------------: |
| DAI    | 0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F |
| USDT   | 0xA02f6adc7926efeBBd59Fd43A84f4E0c0c91e832 |
| USDC   | 0xe6b8a5CF854791412c1f6EFC7CAf629f5Df1c747 |

### Tokens contracts addresses for POLYGON Mainnet

| Tokens |                                  Addresses |
| ------ | -----------------------------------------: |
| DAI    | 0x6B175474E89094C44Da98b954EedeAC495271d0F |
| USDT   | 0xdAC17F958D2ee523a2206206994597C13D831ec7 |
| USDC   | 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48 |

### How to use 🤔

1.  Create your own .env file
2.  Add the specified keys to your .env file
3.  Run `yarn install` or `npm install`
4.  Run the following command to compile and deploy the contract:

```shell
npx hardhat compile
npm run deploy:goerli
```

### Environment variables 📝

| Item                  |                                                   Value |
| --------------------- | ------------------------------------------------------: |
| RPC_GOERLI            |          Add your alchemy RPC server for goerli testnet |
| RPC_MUMBAI            |  Add your alchemy RPC server for mumbai polygon testnet |
| RPC_ETHMAINNET        |        Add your alchemy RPC server for ethereum mainnet |
| RPC_POLYGON           |         Add your alchemy RPC server for polygon mainnet |
| ETHERSCAN_API_KEY     |                           API Key provided by etherscan |
| POLYGONSCAN_API_KEY   |                         API Key provided by polygonscan |
| PRIVATE_KEY           |                                 Your wallet private key |
| COINMARKETCAP_API_KEY |                         In case you want the gas-report |
| CHAIN                 | Specify it for internal validation regarded to scanners |
