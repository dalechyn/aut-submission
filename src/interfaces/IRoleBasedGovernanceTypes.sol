// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

/// @notice This interface is used to define the types used in the RoleBasedGovernance contract.
interface IRoleBasedGovernanceTypes {
    enum ProposalStatus {
        PROPOSED,
        FAILED,
        PASSED
    }

    struct Proposal {
        uint256 id;
        string metadata;
        int256 voting;
        uint256 startTime;
        uint256 endTime;
        int256 quorum;
    }
}
