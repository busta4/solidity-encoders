// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {Test} from "forge-std/Test.sol";
import {ABIEncoderDemo} from "../src/ABIEncoderDemo.sol";

/// @title ABIEncoderDemoTest
contract ABIEncoderDemoTest is Test {
    ABIEncoderDemo private demo;

    /// @dev Deploy a fresh contract before each test
    function setUp() external {
        demo = new ABIEncoderDemo();
    }

    /// @dev Pool id must be invariant to token ordering (tokens are sorted internally)
    function test_createPoolIdentifier_SameForBothTokenOrders() external view {
        address tokenA = address(0x1000);
        address tokenB = address(0x2000);

        uint24 fee = 3000;
        bytes32 idAB = demo.createPoolIdentifier(tokenA, tokenB, fee);
        bytes32 idBA = demo.createPoolIdentifier(tokenB, tokenA, fee);

        assertEq(idAB, idBA, "Tokens are not correctly sorted");
    }

    function test_createPoolIdentifier_DifferentFeeDifferentId() external view {
        address tokenA = address(0x1000);
        address tokenB = address(0x2000);

        uint24 fee0 = 3000;
        uint24 fee1 = 500;

        bytes32 idLow = demo.createPoolIdentifier(tokenA, tokenB, fee0);
        bytes32 idHigh = demo.createPoolIdentifier(tokenB, tokenA, fee1);

        assertTrue(idLow != idHigh, "different fees must yield different ids");
    }

    function test_encodeTradingPosition_ReturnsExpectedDataAndHash() external {
        address user = address(0x1234);
        address tokenIn = address(0xA1);
        address tokenOut = address(0xB2);
        uint256 amountIn = 1 ether;
        uint256 minAmountOut = 2 ether;

        // Freeze block timestamp to a known value
        uint256 fixedTs = 1_700_000_000;
        vm.warp(fixedTs);

        (bytes32 positionId, bytes memory encodedData) = demo
            .encodeTradingPosition(
                user,
                tokenIn,
                tokenOut,
                amountIn,
                minAmountOut
            );

        bytes memory expected = abi.encodePacked(
            user,
            tokenIn,
            tokenOut,
            amountIn,
            minAmountOut,
            fixedTs
        );

        assertEq(encodedData, expected, "encoded trading position mismatch");
        assertEq(
            positionId,
            keccak256(expected),
            "position id must be keccak of encodedData"
        );
    }

    function test_encodeSwapData_EncodesPathAmountsDeadline() external {
        address[] memory path = new address[](3);
        path[0] = address(0x1);
        path[1] = address(0x2);
        path[2] = address(0x3);

        uint256[] memory amounts = new uint256[](3);
        amounts[0] = 10;
        amounts[1] = 20;
        amounts[2] = 30;

        uint256 deadline = 999;

        bytes memory pathData;
        for (uint256 i; i < path.length; i++) {
            pathData = abi.encodePacked(pathData, path[i]);
        }

        bytes memory amountsData;
        for (uint256 i; i < path.length; i++) {
            pathData = abi.encodePacked(amountsData, amounts[i]);
        }

        bytes memory expected = abi.encodePacked(
            pathData,
            amountsData,
            deadline
        );
        bytes memory actual = demo.encodeSwapData(path, amounts, deadline);

        assertEq(expected, actual, "swap data encoding mismatch");
    }

    function test_encodeSwapData_RevertsOnLengthMismatch() external {
        address[] memory path = new address[](2);
        path[0] = address(0x1);
        path[1] = address(0x2);

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 10;

        vm.expectRevert(
            abi.encodeWithSignature("Error(string)", "Array length mismatch")
        );
        demo.encodeSwapData(path, amounts, 123);
    }
}
