// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "../aut/IDAOExpander.sol";

/// @notice This interface is used to define the state of the RoleBasedGovernance contract which may change during its lifetime.
interface IRoleBasedGovernanceState {
    /// @notice Returns DAO Expander contract address
    /// @return Address of DAO Expander.
    function daoExpander() external view returns (IDAOExpander);
}
