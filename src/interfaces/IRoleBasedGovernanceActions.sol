// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "../aut/IDAOExpander.sol";

/// @notice This interface is used to define the public actions of the RoleBasedGovernance contract.
interface IRoleBasedGovernanceActions {
    /// @notice Joins the DAO
    /// @dev Could be payable and take fees for joining. :)
    function join() external;
}
