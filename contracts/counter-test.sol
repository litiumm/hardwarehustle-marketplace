// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.27;
import "hardhat/console.sol";

contract CounterTest {
        uint count;

        constructor() public {
                count = 0;
        }

        function getCount() public view returns(uint) {
                return count;
        }

        function incrementCount() public {
                count = count + 1;
        }
}
