// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.9;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SafeERC20 } from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

import { ReserveToken, ReserveTokenLibrary } from "../token/ReserveToken.sol";

import { Vault } from "./Vault.sol";

/**
 * @dev Bancor Vault contract
 */
contract StakingRewardsVault is Vault {
    using SafeERC20 for IERC20;
    using ReserveTokenLibrary for ReserveToken;

    // the asset manager role is required to access all the reserves
    bytes32 public constant ROLE_ASSET_MANAGER = keccak256("ROLE_ASSET_MANAGER");

    // upgrade forward-compatibility storage gap
    uint256[MAX_GAP - 0] private __gap;

    /**
     * @dev a "virtual" constructor that is only used to set immutable state variables
     */
    constructor() {}

    /**
     * @dev fully initializes the contract and its parents
     */
    function initialize() external initializer {
        __StakingRewardsVault_init();
    }

    // solhint-disable func-name-mixedcase

    /**
     * @dev initializes the contract and its parents
     */
    function __StakingRewardsVault_init() internal initializer {
        __Vault_init();

        __StakingRewardsVault_init_unchained();
    }

    /**
     * @dev performs contract-specific initialization
     */
    function __StakingRewardsVault_init_unchained() internal initializer {
        // set up administrative roles
        _setRoleAdmin(ROLE_ASSET_MANAGER, ROLE_ASSET_MANAGER);

        // allow the deployer to initially manage the assets of the contract
        _setupRole(ROLE_ASSET_MANAGER, msg.sender);
    }

    /**
     * @inheritdoc Vault
     */
    function isPayable() public pure override returns (bool) {
        return true;
    }

    /**
     * @dev returns the current version of the contract
     */
    function version() external pure override returns (uint16) {
        return 1;
    }

    /**
     * @dev authenticate the right of a caller to withdraw a specific amount of a token to a target
     *
     * requirements:
     *
     * - the caller must have the right privileges to withdraw this token:
     *   - the ROLE_ASSET_MANAGER role
     */
    function authenticateWithdrawal(
        address caller,
        ReserveToken,
        address,
        uint256
    ) public view override returns (bool) {
        if (hasRole(ROLE_ASSET_MANAGER, caller)) {
            return true;
        }
        return false;
    }
}
