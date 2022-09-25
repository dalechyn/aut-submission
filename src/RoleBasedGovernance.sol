// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "./interfaces/IRoleBasedGovernance.sol";
import "./aut/IAutID.sol";
import "./aut/IDAOExpanderRegistry.sol";
import "./aut/IDAOExpander.sol";

import "@openzeppelin/contracts/access/Ownable.sol";

contract RoleBasedGovernance is Ownable, IRoleBasedGovernance {
    enum Roles {
        NONE,
        A,
        B,
        C
    }

    int256 public constant ROLE_A_WEIGHT = 10;
    int256 public constant ROLE_B_WEIGHT = 21;
    int256 public constant ROLE_C_WEIGHT = 18;

    /// @inheritdoc IRoleBasedGovernanceImmutables
    IAutID public immutable override autID;
    /// @inheritdoc IRoleBasedGovernanceState
    IDAOExpander public override daoExpander;

    mapping(uint256 => mapping(address => bool)) private _votesRegistry;
    Proposal[] private _proposals;
    address[] private _members;

    constructor(IAutID _autID) Ownable() {
        require(address(_autID) != address(0), "RoleBasedGovernance: AutID address cannot be 0x0");

        autID = _autID;
    }

    /// @inheritdoc IRoleBasedGovernanceActions
    function join() external override {
        require(!isMember(_msgSender()), "RoleBasedGovernance: Member already joined the DAO");

        _members.push(_msgSender());

        emit Joined(_msgSender());
    }

    /// @inheritdoc IRoleBasedGovernanceOwnerActions
    function setDAOExpander(IDAOExpander _daoExpander) external override onlyOwner {
        require(address(_daoExpander) != address(0), "RoleBasedGovernance: DAOExpander address cannot be 0x0");

        daoExpander = _daoExpander;

        emit DAOExpanderSet(address(daoExpander));
    }

    modifier onlyMember() {
        require(isMember(_msgSender()), "RoleBasedGovernance: Only members can call this function");
        _;
    }

    /// @inheritdoc IRoleBasedGovernanceMemberActions
    function propose(uint256 startTime, uint256 endTime, int256 quorum, string memory metadata)
        external
        override
        onlyMember
        returns (Proposal memory proposal)
    {
        require(startTime < endTime, "RoleBasedGovernance: startTime must be before endTime");
        require(startTime >= block.timestamp, "RoleBasedGovernance: startTime must be in the future or now");

        proposal = Proposal({
            id: _proposals.length,
            metadata: metadata,
            voting: 0,
            startTime: startTime,
            endTime: endTime,
            quorum: quorum
        });

        _proposals.push(proposal);

        emit ProposalCreated(proposal.id, proposal.metadata, proposal.startTime, proposal.endTime, proposal.quorum);
    }

    /// @inheritdoc IRoleBasedGovernanceMemberActions
    function vote(uint256 proposalId, bool voteResult) external override onlyMember {
        require(_votesRegistry[proposalId][_msgSender()] == false, "RoleBasedGovernance: Sender has already voted");

        Proposal storage proposal = _proposals[proposalId];
        require(proposal.startTime < block.timestamp, "RoleBasedGovernance: Voting has not started yet");
        require(proposal.endTime > block.timestamp, "RoleBasedGovernance: Voting has ended");

        _votesRegistry[proposalId][_msgSender()] = true;

        Roles role = Roles(autID.getMembershipData(_msgSender(), address(daoExpander)).role);
        int256 votingPower;
        if (role == Roles.A) {
            votingPower = ROLE_A_WEIGHT;
        } else if (role == Roles.B) {
            votingPower = ROLE_B_WEIGHT;
        } else if (role == Roles.C) {
            votingPower = ROLE_C_WEIGHT;
        } else revert("RoleBasedGovernance: Sender is not a member of the DAO");

        require(proposal.voting + votingPower <= proposal.quorum, "RoleBasedGovernance: Quorum reached");
        if (voteResult) {
            proposal.voting += votingPower;
        } else {
            proposal.voting -= votingPower;
        }

        emit Voted(_msgSender(), proposalId, votingPower);
    }

    /// @inheritdoc IRoleBasedGovernanceDerivedState
    function getProposal(uint256 proposalId)
        external
        view
        override
        returns (Proposal memory proposal, ProposalStatus status)
    {
        proposal = _proposals[proposalId];

        if (proposal.voting >= proposal.quorum) {
            status = ProposalStatus.PASSED;
        } else if (proposal.endTime < block.timestamp) {
            status = ProposalStatus.FAILED;
        } else {
            status = ProposalStatus.PROPOSED;
        }
    }

    /// @inheritdoc IRoleBasedGovernanceDerivedState
    function getActiveProposalIDs() external view override returns (uint256[] memory proposalIds) {
        uint256 activeProposalsCount;
        for (uint256 i = 0; i < _proposals.length; i++) {
            if (_proposals[i].endTime > block.timestamp) {
                activeProposalsCount++;
            }
        }

        proposalIds = new uint256[](activeProposalsCount);
        uint256 activeProposalsIndex;
        for (uint256 i = 0; i < _proposals.length; i++) {
            if (_proposals[i].endTime > block.timestamp) {
                proposalIds[activeProposalsIndex] = i;
                activeProposalsIndex++;
            }
        }
    }

    // looks weird – but required for DAOExpander's original DAO membership check
    // we won't handle the list of dao members since DAOExpander already does this =)
    function isMember(address member) public view returns (bool) {
        // an owner is always a member
        if (member == owner()) {
            return true;
        }

        for (uint256 i = 0; i < _members.length; i++) {
            if (_members[i] == member) {
                return true;
            }
        }
        return false;
    }
}
