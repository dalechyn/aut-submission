// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "./IRoleBasedGovernanceMemberActions.sol";
import "./IRoleBasedGovernanceOwnerActions.sol";
import "./IRoleBasedGovernanceImmutables.sol";
import "./IRoleBasedGovernanceTypes.sol";
import "./IRoleBasedGovernanceEvents.sol";
import "./IRoleBasedGovernanceDerivedState.sol";
import "./IRoleBasedGovernanceState.sol";
import "./IRoleBasedGovernanceActions.sol";

/// @notice The interface of RoleBasedGovernance contract. Split up for readability.
interface IRoleBasedGovernance is
    IRoleBasedGovernanceImmutables,
    IRoleBasedGovernanceState,
    IRoleBasedGovernanceDerivedState,
    IRoleBasedGovernanceTypes,
    IRoleBasedGovernanceEvents,
    IRoleBasedGovernanceActions,
    IRoleBasedGovernanceOwnerActions,
    IRoleBasedGovernanceMemberActions
{}
