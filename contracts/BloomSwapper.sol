// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./BloomTreasure.sol";

contract Router {
    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts) {}

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts) {}

    function WETH() external pure returns (address) {}

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts) {}
}

// Author: @alexFiorenza
contract BloomSwapper {
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    Router private router = Router(UNISWAP_V2_ROUTER);
    BloomTreasure private treasure;
    address private TREASURE;
    address private DAI;
    address private USDT;
    address private USDC;
    IERC20 private dai;
    IERC20 private usdt;
    IERC20 private usdc;

    constructor(
        address _dai,
        address _usdc,
        address _usdt,
        address _treasure
    ) {
        dai = IERC20(_dai);
        DAI = _dai;
        usdt = IERC20(_usdt);
        USDT = _usdt;
        usdc = IERC20(_usdc);
        USDC = _usdc;
        treasure = BloomTreasure(_treasure);
        TREASURE = _treasure;
    }

    modifier minimumAmount(uint256 amount) {
        require(amount > 0, "Amount must be greater than 0");
        _;
    }

    function getTreasureAddress() public view returns (address) {
        return TREASURE;
    }

    /// @notice Sends ETHS to another address
    /// @param to The address to send ETHS to
    function sendETHToAddress(address to) external payable {
        uint256 fee = treasure.calculateFee(msg.value);
        require(
            address(this).balance > fee,
            "Fee is greater than the amount sent"
        );
        treasure.fundTreasureWithETH{value: fee}();
        uint256 newAmount = msg.value - fee;
        payable(to).transfer(newAmount);
    }

    /** DAI CONTRACT FUNCTIONS */

    /// @notice Sends DAI to another address
    /// @param to The address to send DAI to
    /// @param amount Amount to send
    function sendDAIToAddress(address to, uint256 amount)
        public
        minimumAmount(amount)
    {
        uint256 fee = treasure.calculateFee(amount);
        uint256 newAmount = amount - fee;
        require(
            dai.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        dai.transfer(to, newAmount);
        fundTreasureWithToken("DAI", fee);
    }

    /// @notice Swaps DAI for ETH
    /// @param amount Amount of DAI to swap to eth
    /// @param ethAddress Address to send eths
    /// @return Amount of eths sent
    function sendDAIToETHAddress(uint256 amount, address ethAddress)
        external
        minimumAmount(amount)
        returns (uint256)
    {
        uint256 fee = treasure.calculateFee(amount);
        uint256 newAmount = amount - fee;
        require(
            dai.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        fundTreasureWithToken("DAI", fee);
        require(
            dai.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](2);
        path[0] = DAI;
        path[1] = router.WETH();

        uint256[] memory amounts = router.swapExactTokensForETH(
            newAmount,
            0,
            path,
            ethAddress,
            block.timestamp
        );
        return amounts[1];
    }

    /// @notice Swaps ETH for DAI
    /// @param daiAddress dai address to be sent the money
    /// @return Amount of DAI received
    /// @dev ETH must be sent with the transaction in msg.value
    function sendETHToDAIAddress(address daiAddress)
        external
        payable
        returns (uint256)
    {
        address[] memory path;
        path = new address[](2);
        path[0] = router.WETH();
        path[1] = DAI;
        uint256 fee = treasure.calculateFee(msg.value);
        require(
            address(this).balance > fee,
            "Fee is greater than the amount sent"
        );
        treasure.fundTreasureWithETH{value: fee}();
        uint256[] memory amounts = router.swapExactETHForTokens{
            value: msg.value - fee
        }(0, path, daiAddress, block.timestamp);
        return amounts[1];
    }

    /// @notice Swaps DAI for USDT
    /// @param amount Amount of DAI to swap
    /// @param usdtAddress usdt address to be sent the money
    /// @return Amount of USDT received
    function sendDAIToUSDTAddress(uint256 amount, address usdtAddress)
        external
        minimumAmount(amount)
        returns (uint256)
    {
        uint256 fee = treasure.calculateFee(amount);
        uint256 newAmount = amount - fee;
        require(
            dai.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        fundTreasureWithToken("DAI", fee);
        require(
            dai.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](3);
        path[0] = DAI;
        path[1] = router.WETH();
        path[2] = USDT;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            newAmount,
            0,
            path,
            usdtAddress,
            block.timestamp
        );
        return amounts[2];
    }

    /// @notice Swaps DAI for USDC
    /// @param amount Amount of DAI to swap
    /// @param usdcAddress USDC address to be sent the money
    /// @return Amount of USDC received
    function sendDAIToUSDCAddress(uint256 amount, address usdcAddress)
        external
        minimumAmount(amount)
        returns (uint256)
    {
        uint256 fee = treasure.calculateFee(amount);
        uint256 newAmount = amount - fee;
        require(
            dai.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        fundTreasureWithToken("DAI", fee);
        require(
            dai.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](3);
        path[0] = DAI;
        path[1] = router.WETH();
        path[2] = USDC;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            newAmount,
            0,
            path,
            usdcAddress,
            block.timestamp
        );
        return amounts[2];
    }

    /** TETHER USDT CONTRACT FUNCTIONS */
    /// @notice Sends USDC to another address
    /// @param to The address to send USDC to
    /// @param amount Amount to send
    function sendUSDTTOAddress(address to, uint256 amount)
        public
        minimumAmount(amount)
    {
        uint256 fee = treasure.calculateFee(amount);
        uint256 newAmount = amount - fee;
        require(
            usdt.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        usdt.transfer(to, newAmount);
        fundTreasureWithToken("USDT", fee);
    }

    /// @notice Swaps ETH for USDT
    /// @param usdtAddress USDT address to be sent the money
    /// @return Amount of USDT received
    /// @dev ETH must be sent with the transaction in msg.value
    function sendETHToUSDTAddress(address usdtAddress)
        external
        payable
        minimumAmount(msg.value)
        returns (uint256)
    {
        address[] memory path;
        path = new address[](2);
        path[0] = router.WETH();
        path[1] = DAI;
        uint256 fee = treasure.calculateFee(msg.value);
        require(
            address(this).balance > fee,
            "Fee is greater than the amount sent"
        );
        treasure.fundTreasureWithETH{value: fee}();
        uint256[] memory amounts = router.swapExactETHForTokens{
            value: msg.value - fee
        }(0, path, usdtAddress, block.timestamp);
        return amounts[1];
    }

    /// @notice Swaps USDT for ETH
    /// @param ethAddress ETH address to be sent the money
    /// @param amount Amount of USDT to swap
    /// @return Amount of ETH received
    function sendUSDTToETHAddress(uint256 amount, address ethAddress)
        external
        minimumAmount(amount)
        returns (uint256)
    {
        uint256 fee = treasure.calculateFee(amount);
        uint256 newAmount = amount - fee;
        require(
            usdt.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        fundTreasureWithToken("USDT", fee);
        require(
            usdt.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](2);
        path[0] = USDT;
        path[1] = router.WETH();

        uint256[] memory amounts = router.swapExactTokensForETH(
            newAmount,
            0,
            path,
            ethAddress,
            block.timestamp
        );
        return amounts[1];
    }

    /// @notice Swaps USDT for DAI
    /// @param amount Amount of USDT to swap
    /// @param daiAddress DAI address to be sent the money
    /// @return Amount of DAI received
    function sendUSDToDAIAddress(uint256 amount, address daiAddress)
        external
        minimumAmount(amount)
        returns (uint256)
    {
        uint256 fee = treasure.calculateFee(amount);
        uint256 newAmount = amount - fee;
        require(
            usdt.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        fundTreasureWithToken("USDT", fee);
        require(
            usdt.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](3);
        path[0] = USDT;
        path[1] = router.WETH();
        path[2] = DAI;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            newAmount,
            0,
            path,
            daiAddress,
            block.timestamp
        );
        return amounts[2];
    }

    /// @notice Swaps USDT for USDC
    /// @param amount Amount of USDT to swap
    /// @param usdcAddress USDC address to be sent the money
    /// @return Amount of USDC received
    function sendUSDTToUSDCAddress(uint256 amount, address usdcAddress)
        external
        minimumAmount(amount)
        returns (uint256)
    {
        uint256 fee = treasure.calculateFee(amount);
        uint256 newAmount = amount - fee;
        require(
            usdt.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        fundTreasureWithToken("USDT", fee);
        require(
            usdt.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](3);
        path[0] = USDT;
        path[1] = router.WETH();
        path[2] = USDC;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            newAmount,
            0,
            path,
            usdcAddress,
            block.timestamp
        );
        return amounts[2];
    }

    /** USDC COIN CONTRACT FUNCTIONS */
    /// @notice Sends USDC to another address
    /// @param to The address to send USDC to
    /// @param amount Amount to send
    function sendUSDCToAddress(address to, uint256 amount)
        public
        minimumAmount(amount)
    {
        uint256 fee = treasure.calculateFee(amount);
        uint256 newAmount = amount - fee;
        require(
            usdc.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        usdc.transfer(to, newAmount);
        fundTreasureWithToken("USDC", fee);
    }

    /// @notice Swaps ETH for USDC
    /// @return Amount of USDC received
    /// @param usdcAddress USDC address to be sent the money
    /// @dev ETH must be sent with the transaction in msg.value
    function sendETHToUSDCAddress(address usdcAddress)
        external
        payable
        minimumAmount(msg.value)
        returns (uint256)
    {
        address[] memory path;
        path = new address[](2);
        path[0] = router.WETH();
        path[1] = USDC;
        uint256 fee = treasure.calculateFee(msg.value);
        uint256 amountToSwap = msg.value - fee;
        treasure.fundTreasureWithETH{value: fee}();
        uint256[] memory amounts = router.swapExactETHForTokens{
            value: amountToSwap
        }(0, path, usdcAddress, block.timestamp);
        return amounts[1];
    }

    /// @notice Swaps USDC for ETH
    /// @param amount Amount of USDT to swap
    /// @param ethAddress ETH address to be sent the money
    /// @return Amount of ETH received
    function sendUSDCToETHAddress(uint256 amount, address ethAddress)
        external
        minimumAmount(amount)
        returns (uint256)
    {
        uint256 fee = treasure.calculateFee(amount);
        uint256 newAmount = amount - fee;
        require(
            usdc.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        fundTreasureWithToken("USDC", fee);
        require(
            usdc.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](2);
        path[0] = USDC;
        path[1] = router.WETH();

        uint256[] memory amounts = router.swapExactTokensForETH(
            newAmount,
            0,
            path,
            ethAddress,
            block.timestamp
        );
        return amounts[1];
    }

    /// @notice Swaps USDC for DAI
    /// @param amount Amount of USDC to swap
    /// @param daiAddress DAI address to be sent the money
    /// @return Amount of DAI received
    function sendUSDCToDAIAddress(uint256 amount, address daiAddress)
        external
        minimumAmount(amount)
        returns (uint256)
    {
        uint256 fee = treasure.calculateFee(amount);
        uint256 newAmount = amount - fee;
        require(
            usdc.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        fundTreasureWithToken("USDC", fee);
        require(
            usdc.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](3);
        path[0] = USDC;
        path[1] = router.WETH();
        path[2] = DAI;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            newAmount,
            0,
            path,
            daiAddress,
            block.timestamp
        );
        return amounts[2];
    }

    /// @notice Swaps USDC for USDT
    /// @param amount Amount of USDC to swap
    /// @param usdtAddress USDT Address to be sent the money
    /// @return Amount of USDT received
    function sendUSDCToUSDTAddress(uint256 amount, address usdtAddress)
        external
        minimumAmount(amount)
        returns (uint256)
    {
        uint256 fee = treasure.calculateFee(amount);
        uint256 newAmount = amount - fee;
        require(
            usdc.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        fundTreasureWithToken("USDC", fee);
        require(
            usdc.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](3);
        path[0] = USDC;
        path[1] = router.WETH();
        path[2] = USDT;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            newAmount,
            0,
            path,
            usdtAddress,
            block.timestamp
        );
        return amounts[2];
    }

    function fundTreasureWithToken(string memory token, uint256 amount)
        private
    {
        if (compareStrings(token, "DAI")) {
            require(dai.transfer(TREASURE, amount), "Fee payment failed");
        }
        if (compareStrings(token, "USDC")) {
            require(usdc.transfer(TREASURE, amount), "Fee payment failed");
        }
        if (compareStrings(token, "USDT")) {
            require(usdt.transfer(TREASURE, amount), "Fee payment failed");
        }
        treasure.updateInternalBalanceOfTokens();
    }

    function compareStrings(string memory a, string memory b)
        internal
        pure
        returns (bool)
    {
        return (keccak256(abi.encodePacked((a))) ==
            keccak256(abi.encodePacked((b))));
    }
}
