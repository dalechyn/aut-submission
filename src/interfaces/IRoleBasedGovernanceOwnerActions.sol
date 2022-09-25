// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "../aut/IDAOExpander.sol";

/// @notice This interface is used to define the owner actions of the RoleBasedGovernance contract.
interface IRoleBasedGovernanceOwnerActions {
    /// @notice Sets the DAO Expander contract address
    /// @dev In order to fetch the roles from AutID contract, the DAO Expander contract address must be set.
    /// @param _daoExpander The address of the DAO Expander contract
    function setDAOExpander(IDAOExpander _daoExpander) external;
}
