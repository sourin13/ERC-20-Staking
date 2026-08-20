// SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../src/MyToken.sol";
import "../src/Staking.sol";

contract StakingTest is Test {
    MyToken token;
    Staking staking;

    address alice = address(1);

    function setUp() public {
        token = new MyToken();
        staking = new Staking(address(token));

        token.transfer(alice, 1000 ether);
        token.approve(address(staking), 1000 ether);
        staking.fundRewards(1000 ether);
    }

    function testStake() public {
        vm.startPrank(alice);
        token.approve(address(staking), 100 ether);

        staking.stake(100 ether);

        vm.stopPrank();

        assertEq(token.balanceOf(alice), 900 ether);

        assertEq(token.balanceOf(address(staking)), 1100 ether);

        (uint256 amount, uint256 startTime) = staking.stakes(alice);

        assertEq(amount, 100 ether);
        assertEq(startTime, block.timestamp);
    }

    function testCalculateReward() public {
        vm.startPrank(alice);

        token.approve(address(staking), 100 ether);
        staking.stake(100 ether);

        vm.stopPrank();

        // Move blockchain time forward by 1 year
        vm.warp(block.timestamp + 365 days);

        uint256 reward = staking.calculateReward(alice);

        assertEq(reward, 10 ether);
    }

    function testStakeEmitsEvent() public {
        vm.startPrank(alice);

        token.approve(address(staking), 100 ether);

        vm.expectEmit(true, false, false, true);

        emit Staking.Staked(alice, 100 ether);

        staking.stake(100 ether);

        vm.stopPrank();
    }

    function testWithdrawEmitsEvent() public {
        vm.startPrank(alice);

        token.approve(address(staking), 100 ether);
        staking.stake(100 ether);

        vm.stopPrank();

        vm.warp(block.timestamp + 365 days);

        vm.expectEmit(true, false, false, true);

        emit Staking.Withdrawn(alice, 100 ether, 10 ether);

        vm.prank(alice);
        staking.withdraw();
    }

    function testStakeZero() public {
        vm.prank(alice);

        vm.expectRevert("Amount must be greater than 0");

        staking.stake(0);
    }

    function testwithdrwanwithoutStake() public {
        vm.prank(alice);

        vm.expectRevert("No stake");

        staking.withdraw();
    }

    function testMultipleStakes() public {
        vm.startPrank(alice);

        token.approve(address(staking), 150 ether);

        staking.stake(100 ether);
        staking.stake(50 ether);

        vm.stopPrank();

        (uint256 amount, uint256 startTime) = staking.stakes(alice);

        assertEq(amount, 150 ether);
        assertEq(startTime, block.timestamp);

        assertEq(token.balanceOf(alice), 850 ether);
    }
}
