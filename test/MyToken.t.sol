//SPDX-License_Identifier:MIT
pragma solidity ^0.8.18;

import "forge-std/Test.sol";
import "../src/MyToken.sol";

contract MyTokenTest is Test{
    MyToken public token;
    address alice=address(1);
    address bob=address(2);

    function setUp() public{
        token=new MyToken();
    }

    function testInitialSupply() public{
        assertEq(
            token.totalSupply(),
            1000000*10**18
        );
        assertEq(
            token.balanceOf(address(this)),
            1000000*10**18
        );}
        
        function testTransfer() public{
            token.transfer(alice,100 ether);
            assertEq(token.balanceOf(alice),100 ether);
        }
        function testTransferInsufficientBalance() public{
            vm.expectRevert("Insufficient Balance");
            vm.prank(alice);
            token.transfer(bob,1);
        }

        function testApprove() public{
            token.approve(alice,100);

            assertEq(token.allowance(address(this),alice),100);

        }

        function testTransferFrom() public{
            token.approve(alice,100 ether);
            vm.prank(alice);
            token.transferFrom(address(this),bob,100 ether );

            assertEq(token.balanceOf(address(this)), 1000000*10**18-100 ether);
            assertEq(token.balanceOf(bob),100 ether);
            assertEq(token.allowance(address(this),alice),0);

        }

        function testTransferFromInsufficientAllowance() public{
            token.approve(alice,100 ether);
            vm.expectRevert("Insufficient Allowance");
            vm.prank(alice);
            token.transferFrom(address(this),bob,200 ether);


        }
    }

