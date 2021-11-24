// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.10;
pragma abicoder v2;

import { IBancorNetwork } from "../network/interfaces/IBancorNetwork.sol";

import { IPoolToken } from "../pools/interfaces/IPoolToken.sol";
import { WithdrawalAmounts } from "../pools/interfaces/IMasterPool.sol";
import { MasterPool } from "../pools/MasterPool.sol";

contract TestMasterPool is MasterPool {
    constructor(IBancorNetwork initNetwork, IPoolToken initPoolToken) MasterPool(initNetwork, initPoolToken) {}

    function withdrawalAmountsT(uint256 poolTokenAmount) external view returns (WithdrawalAmounts memory) {
        return _withdrawalAmounts(poolTokenAmount);
    }
}