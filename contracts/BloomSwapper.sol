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
    event Log(string message);
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    Router private router = Router(UNISWAP_V2_ROUTER);
    BloomTreasure private treasure;
    address private TREASURE;
    address private DAI;
    address private WETH;
    address private USDT;
    address private USDC;
    IERC20 private dai;
    IERC20 private weth;
    IERC20 private usdt;
    IERC20 private usdc;

    constructor(
        address _dai,
        address _usdc,
        address _usdt,
        address _weth,
        address _treasure
    ) {
        dai = IERC20(_dai);
        DAI = _dai;
        weth = IERC20(_weth);
        WETH = _weth;
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

    /** DAI CONTRACT FUNCTIONS */

    /// @notice Sends DAI to another address
    /// @param to The address to send DAI to
    /// @param amount Amount to send
    function sendDAIToAddress(address to, uint256 amount)
        public
        minimumAmount(amount)
    {
        uint256 fee = treasure.calculateFee(amount);
        require(dai.transferFrom(msg.sender, to, amount), "Transfer failed");
        treasure.fundTreasureWithToken("DAI", fee, msg.sender);
        require(dai.approve(address(this), amount), "Approve failed");
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
        require(
            dai.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        uint256 fee = treasure.calculateFee(amount);
        treasure.fundTreasureWithToken("DAI", fee, msg.sender);
        require(
            dai.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](2);
        path[0] = DAI;
        path[1] = router.WETH();

        uint256[] memory amounts = router.swapExactTokensForETH(
            amount,
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
        treasure.fundTreasureWithETH{value: fee}(msg.sender);
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
        require(
            dai.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        require(
            dai.transferFrom(msg.sender, TREASURE, fee),
            "Fee transfer failed"
        );
        require(
            dai.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](3);
        path[0] = DAI;
        path[1] = WETH;
        path[2] = USDT;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            amount,
            0,
            path,
            usdtAddress,
            block.timestamp
        );
        return amounts[1];
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
        require(
            dai.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        require(
            dai.transferFrom(msg.sender, TREASURE, fee),
            "Fee transfer failed"
        );
        require(
            dai.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](2);
        path[0] = DAI;
        path[1] = WETH;
        path[2] = USDC;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            amount,
            0,
            path,
            usdcAddress,
            block.timestamp
        );
        return amounts[2];
    }

    /** TETHER USDT CONTRACT FUNCTIONS */

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
        path[1] = USDT;
        uint256 fee = treasure.calculateFee(msg.value);
        require(
            address(this).balance > fee,
            "Fee is greater than the amount sent"
        );
        treasure.fundTreasureWithETH{value: fee}(msg.sender);
        uint256 amountToSwap = msg.value - fee;
        uint256[] memory amounts = router.swapExactETHForTokens{
            value: amountToSwap
        }(0, path, usdtAddress, block.timestamp);
        return amounts[1];
    }

    /// @notice Swaps USDT for ETH
    /// @param ethAddress ETH address to be sent the money
    /// @param amount Amount of USDT to swap
    /// @return Amount of ETH received
    function sendUSDTToEthAddress(uint256 amount, address ethAddress)
        external
        minimumAmount(amount)
        returns (uint256)
    {
        uint256 fee = treasure.calculateFee(amount);
        require(
            usdt.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        require(
            usdt.transferFrom(msg.sender, TREASURE, fee),
            "Fee transfer failed"
        );
        require(
            usdt.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](2);
        path[0] = USDT;
        path[1] = router.WETH();
        uint256[] memory amounts = router.swapExactTokensForETH(
            amount,
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
        require(
            usdt.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        require(
            usdt.transferFrom(msg.sender, TREASURE, fee),
            "Fee transfer failed"
        );
        require(
            usdt.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](3);
        path[0] = USDT;
        path[1] = WETH;
        path[2] = DAI;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            amount,
            0,
            path,
            daiAddress,
            block.timestamp
        );
        return amounts[1];
    }

    /// @notice Swaps USDT for USDC
    /// @param amount Amount of USDT to swap
    /// @param usdcAddress USDC address to be sent the money
    /// @return Amount of USDC received
    function sendUSDToUSDCAddress(uint256 amount, address usdcAddress)
        external
        minimumAmount(amount)
        returns (uint256)
    {
        uint256 fee = treasure.calculateFee(amount);
        require(
            usdt.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        require(
            usdt.transferFrom(msg.sender, TREASURE, fee),
            "Fee transfer failed"
        );
        require(
            usdt.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](3);
        path[0] = USDT;
        path[1] = WETH;
        path[2] = USDC;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            amount,
            0,
            path,
            usdcAddress,
            block.timestamp
        );
        return amounts[1];
    }

    /** USDC COIN CONTRACT FUNCTIONS */

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
        treasure.fundTreasureWithETH{value: fee}(msg.sender);
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
        require(
            usdc.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        require(
            usdc.transferFrom(msg.sender, TREASURE, fee),
            "Fee transfer failed"
        );
        require(
            usdc.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](2);
        path[0] = USDC;
        path[1] = router.WETH();
        uint256[] memory amounts = router.swapExactTokensForETH(
            amount,
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
        require(
            usdc.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        require(
            usdc.transferFrom(msg.sender, TREASURE, fee),
            "Fee transfer failed"
        );
        require(
            usdc.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](3);
        path[0] = USDC;
        path[1] = WETH;
        path[2] = DAI;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            amount,
            0,
            path,
            daiAddress,
            block.timestamp
        );
        return amounts[1];
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
        require(
            usdc.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        require(
            usdc.transferFrom(msg.sender, TREASURE, fee),
            "Fee transfer failed"
        );
        require(
            usdc.approve(UNISWAP_V2_ROUTER, amount),
            "Approval failed: Try approving the contract  token"
        );
        address[] memory path;
        path = new address[](3);
        path[0] = USDC;
        path[1] = WETH;
        path[2] = USDT;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            amount,
            0,
            path,
            usdtAddress,
            block.timestamp
        );
        return amounts[1];
    }
}
