// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "./IRoleBasedGovernanceTypes.sol";

/// @notice This interface is used to define the events of the RoleBasedGovernance contract.
interface IRoleBasedGovernanceEvents {
    /// @notice Emitted when a proposal is created
    /// @param id The id of the proposal
    /// @param metadata The metadata of the proposal
    /// @param startTime The start time of the proposal
    /// @param endTime The end time of the proposal
    /// @param quorum The quorum of the proposal
    event ProposalCreated(uint256 id, string metadata, uint256 startTime, uint256 endTime, int256 quorum);

    /// @notice Emitted when a proposal is voted on
    /// @param id The id of the proposal
    /// @param voter The address of the voter
    /// @param vote The vote power
    event Voted(address indexed voter, uint256 id, int256 vote);

    /// @notice Emitted when a new member joins the DAO
    /// @param member The address of the member
    event Joined(address indexed member);

    /// @notice Emitted when a new DAO Expander contract is set
    /// @param daoExpander The address of the DAO Expander contract
    event DAOExpanderSet(address indexed daoExpander);
}
