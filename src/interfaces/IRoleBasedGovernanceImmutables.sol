// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "../aut/IAutID.sol";
import "../aut/IDAOExpander.sol";

/// @notice This interface is used to define the immutable variables (- will never change) of
/// the RoleBasedGovernance contract.
interface IRoleBasedGovernanceImmutables {
    /// @notice The AutID contract address
    /// @return The address of the AutID contract
    function autID() external view returns (IAutID);
}
