// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "./IRoleBasedGovernanceTypes.sol";

/// @notice This interface is used to define the derived state of the RoleBasedGovernance contract.
interface IRoleBasedGovernanceDerivedState {
    /// @notice Get the proposal and its status with the given id.
    /// @param proposalId The id of the proposal to get.
    /// @return The proposal and its status.
    function getProposal(uint256 proposalId)
        external
        view
        returns (IRoleBasedGovernanceTypes.Proposal memory, IRoleBasedGovernanceTypes.ProposalStatus);

    /// @notice Get all active proposals IDs.
    /// @return Active proposals IDs.
    function getActiveProposalIDs() external view returns (uint256[] memory);
}
