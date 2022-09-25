// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "./IRoleBasedGovernanceTypes.sol";

/// @notice This interface is used to define the member actions of the RoleBasedGovernance contract.
interface IRoleBasedGovernanceMemberActions {
    /// @notice Vote on a proposal
    /// @param proposalId The ID of the proposal to vote on
    /// @param voteResult The vote to cast (yes/no)
    function vote(uint256 proposalId, bool voteResult) external;

    /// @notice Creates a new proposal
    /// @param startTime The start time of the proposal
    /// @param endTime The end time of the proposal
    /// @param quorum The quorum of the proposal
    /// @param metadata The metadata of the proposal
    /// @return The id of the proposal
    function propose(uint256 startTime, uint256 endTime, int256 quorum, string memory metadata)
        external
        returns (IRoleBasedGovernanceTypes.Proposal memory);
}
