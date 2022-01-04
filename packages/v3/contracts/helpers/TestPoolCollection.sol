// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.10;
pragma abicoder v2;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { IBancorNetwork } from "../network/interfaces/IBancorNetwork.sol";
import { INetworkSettings } from "../network/interfaces/INetworkSettings.sol";

import { IMasterPool } from "../pools/interfaces/IMasterPool.sol";
import { IPoolToken } from "../pools/interfaces/IPoolToken.sol";
import { IPoolTokenFactory } from "../pools/interfaces/IPoolTokenFactory.sol";
import { IPoolCollectionUpgrader } from "../pools/interfaces/IPoolCollectionUpgrader.sol";
import { PoolCollection, Pool, PoolLiquidity, WithdrawalAmounts } from "../pools/PoolCollection.sol";
import { AverageRate } from "../pools/PoolAverageRate.sol";

import { Time } from "../utility/Time.sol";

import { ReserveToken } from "../token/ReserveToken.sol";

import { TestTime } from "./TestTime.sol";

contract TestPoolCollection is PoolCollection, TestTime {
    uint16 private immutable _version;

    constructor(
        uint16 initVersion,
        IBancorNetwork initNetwork,
        IERC20 initNetworkToken,
        INetworkSettings initNetworkSettings,
        IMasterPool initMasterPool,
        IPoolTokenFactory initPoolTokenFactory,
        IPoolCollectionUpgrader initPoolCollectionUpgrader
    )
        PoolCollection(
            initNetwork,
            initNetworkToken,
            initNetworkSettings,
            initMasterPool,
            initPoolTokenFactory,
            initPoolCollectionUpgrader
        )
    {
        _version = initVersion;
    }

    function version() external view override returns (uint16) {
        return _version;
    }

    function setTradingLiquidityT(ReserveToken pool, PoolLiquidity calldata liquidity) external {
        _poolData[pool].liquidity = liquidity;
    }

    function setAverageRateT(ReserveToken pool, AverageRate calldata newAverageRate) external {
        _poolData[pool].averageRate = newAverageRate;
    }

    function poolWithdrawalAmountsT(
        ReserveToken pool,
        uint256 basePoolTokenAmount,
        uint256 baseTokenVaultBalance,
        uint256 externalProtectionVaultBalance
    ) external view returns (WithdrawalAmounts memory) {
        return _poolWithdrawalAmounts(pool, basePoolTokenAmount, baseTokenVaultBalance, externalProtectionVaultBalance);
    }

    function mintT(
        ReserveToken pool,
        address recipient,
        uint256 poolTokenAmount
    ) external {
        return _poolData[pool].poolToken.mint(recipient, poolTokenAmount);
    }

    function requestFundingT(
        bytes32 contextId,
        ReserveToken pool,
        uint256 networkTokenAmount
    ) external {
        _masterPool.requestFunding(contextId, pool, networkTokenAmount);
    }

    function _time() internal view virtual override(Time, TestTime) returns (uint32) {
        return TestTime._time();
    }
}
