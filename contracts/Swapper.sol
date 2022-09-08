// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

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
contract Swapper {
    address private constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    Router private router = Router(UNISWAP_V2_ROUTER);
    address private constant DAI = 0x11fE4B6AE13d2a6055C8D9cF65c55bac32B5d844;
    address private constant USDT = 0x509Ee0d083DdF8AC028f2a56731412edD63223B9;
    address private constant USDC = 0x07865c6E87B9F70255377e024ace6630C1Eaa37F;
    IERC20 private dai = IERC20(DAI);
    IERC20 private usdt = IERC20(USDT);
    IERC20 private usdc = IERC20(USDC);

    /*
     *
     *   DAI
     * **/
    function swapDAIToETH(uint256 amount) external returns (uint256) {
        dai.transferFrom(msg.sender, address(this), amount);
        dai.approve(address(router), amount);
        address[] memory path;
        path = new address[](2);
        path[0] = DAI;
        path[1] = router.WETH();
        uint256[] memory amounts = router.swapExactTokensForETH(
            amount,
            0,
            path,
            msg.sender,
            block.timestamp
        );
        return amounts[1];
    }

    function swapETHToDAI() external payable returns (uint256) {
        address[] memory path;
        path = new address[](2);
        path[0] = router.WETH();
        path[1] = DAI;
        uint256[] memory amounts = router.swapExactETHForTokens{
            value: msg.value
        }(0, path, msg.sender, block.timestamp);
        return amounts[1];
    }

    function swapDAIToUSDT(uint256 amount) external returns (uint256) {
        dai.transferFrom(msg.sender, address(this), amount);
        dai.approve(address(router), amount);
        address[] memory path;
        path = new address[](2);
        path[0] = DAI;
        path[1] = USDT;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            amount,
            0,
            path,
            msg.sender,
            block.timestamp
        );
        return amounts[1];
    }

    function swapDAIToUSDC(uint256 amount) external returns (uint256) {
        dai.transferFrom(msg.sender, address(this), amount);
        dai.approve(address(router), amount);
        address[] memory path;
        path = new address[](2);
        path[0] = DAI;
        path[1] = USDC;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            amount,
            0,
            path,
            msg.sender,
            block.timestamp
        );
        return amounts[1];
    }

    /*
     *
     *   USDT
     * **/

    function swapETHToUSDT() external payable returns (uint256) {
        address[] memory path;
        path = new address[](2);
        path[0] = router.WETH();
        path[1] = USDT;
        uint256[] memory amounts = router.swapExactETHForTokens{
            value: msg.value
        }(0, path, msg.sender, block.timestamp);
        return amounts[1];
    }

    function swapUSDTToETH(uint256 amount) external returns (uint256) {
        usdt.transferFrom(msg.sender, address(this), amount);
        usdt.approve(address(router), amount);
        address[] memory path;
        path = new address[](2);
        path[0] = USDT;
        path[1] = router.WETH();
        uint256[] memory amounts = router.swapExactTokensForETH(
            amount,
            0,
            path,
            msg.sender,
            block.timestamp
        );
        return amounts[1];
    }

    function swapUSDTToDAI(uint256 amount) external returns (uint256) {
        usdt.transferFrom(msg.sender, address(this), amount);
        usdt.approve(address(router), amount);
        address[] memory path;
        path = new address[](2);
        path[0] = USDT;
        path[1] = DAI;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            amount,
            0,
            path,
            msg.sender,
            block.timestamp
        );
        return amounts[1];
    }

    function swapUSDTToUSDC(uint256 amount) external returns (uint256) {
        usdt.transferFrom(msg.sender, address(this), amount);
        usdt.approve(address(router), amount);
        address[] memory path;
        path = new address[](2);
        path[0] = USDT;
        path[1] = USDC;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            amount,
            0,
            path,
            msg.sender,
            block.timestamp
        );
        return amounts[1];
    }

    /*
     *
     *   USDC
     * **/
    function swapETHToUSDC() external payable returns (uint256) {
        address[] memory path;
        path = new address[](2);
        path[0] = router.WETH();
        path[1] = USDC;
        uint256[] memory amounts = router.swapExactETHForTokens{
            value: msg.value
        }(0, path, msg.sender, block.timestamp);
        return amounts[1];
    }

    function swapUSDCToETH(uint256 amount) external returns (uint256) {
        usdc.transferFrom(msg.sender, address(this), amount);
        usdc.approve(address(router), amount);
        address[] memory path;
        path = new address[](2);
        path[0] = USDC;
        path[1] = router.WETH();
        uint256[] memory amounts = router.swapExactTokensForETH(
            amount,
            0,
            path,
            msg.sender,
            block.timestamp
        );
        return amounts[1];
    }

    function swapUSDCToDAI(uint256 amount) external returns (uint256) {
        usdc.transferFrom(msg.sender, address(this), amount);
        usdc.approve(address(router), amount);
        address[] memory path;
        path = new address[](2);
        path[0] = USDC;
        path[1] = DAI;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            amount,
            0,
            path,
            msg.sender,
            block.timestamp
        );
        return amounts[1];
    }

    function swapUSDCToUSDT(uint256 amount) external returns (uint256) {
        usdc.transferFrom(msg.sender, address(this), amount);
        usdc.approve(address(router), amount);
        address[] memory path;
        path = new address[](2);
        path[0] = USDC;
        path[1] = USDT;
        uint256[] memory amounts = router.swapExactTokensForTokens(
            amount,
            0,
            path,
            msg.sender,
            block.timestamp
        );
        return amounts[1];
    }
}
