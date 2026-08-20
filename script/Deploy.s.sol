// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "forge-std/Script.sol";
import "../src/MyToken.sol";
import "../src/Staking.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();

        MyToken token = new MyToken();

        Staking staking = new Staking(address(token));

        vm.stopBroadcast();

        console2.log("MyToken deployed at:", address(token));
        console2.log("Staking deployed at:", address(staking));
    }
}
