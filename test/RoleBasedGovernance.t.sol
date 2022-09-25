// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {console2} from "forge-std/console2.sol";
import "../src/RoleBasedGovernance.sol";
import "../src/aut/IDAOExpanderRegistry.sol";
import "../src/aut/IAutID.sol";

contract RoleBasedGovernanceTest is Test {
    RoleBasedGovernance gov;

    address constant DAO_EXPANDER_REGISTRY = 0xd04e9c0fE17D995882D12d3377B5BD5FC6F9D142;
    IAutID constant autID = IAutID(0x56C5E4126B2D2E4b3d4319639d0272420f1FEd4A);
    IDAOExpander expander;

    address owner = 0x0000000000000000000000000000000000000001;
    address bob = 0x0000000000000000000000000000000000000002;
    address alice = 0x0000000000000000000000000000000000000003;
    address carol = 0x0000000000000000000000000000000000000004;
    address dave = 0x0000000000000000000000000000000000000005;
    address eve = 0x0000000000000000000000000000000000000006;

    function setUp() public {
        vm.startPrank(owner);
        gov = new RoleBasedGovernance(autID);
        expander = IDAOExpander(
            IDAOExpanderRegistry(DAO_EXPANDER_REGISTRY).deployDAOExpander(
                1, // SW Legacy - easiest to mimic
                address(gov),
                1, // no docs on this what market argument is for, but should be between 1 and 3 https://github.com/Aut-Protocol/contracts/blob/master/contracts/DAOExpanderRegistry.sol#L46
                "any ipfs CID",
                1 // minimum commitment for members to join this DAO. let it be 1
            )
        );
        gov.setDAOExpander(expander);
        vm.stopPrank();
    }

    function addMember(address member) internal {
        vm.startPrank(member);
        gov.join(); // join to the DAO
        autID.mint(string(abi.encodePacked("cool member", member)), "cool ipfs hash", 1, 2, address(expander)); // mint an AutID token so roles can be fetched
        vm.stopPrank();
    }

    function addMember(address member, RoleBasedGovernance.Roles role) internal {
        vm.startPrank(member);
        gov.join(); // join to the DAO
        autID.mint(
            string(abi.encodePacked("cool member", member)), "cool ipfs hash", uint256(role), 2, address(expander)
        ); // mint an AutID token so roles can be fetched
        vm.stopPrank();
    }

    function testPropose() public {
        addMember(bob);

        vm.startPrank(bob);
        gov.propose(block.timestamp + 1, block.timestamp + 2, 1, "any ipfs CID");
        vm.stopPrank();
    }

    function testRevertsOnProposeIfNotMember() public {
        vm.startPrank(bob); // bob is not the member here

        vm.expectRevert("RoleBasedGovernance: Only members can call this function");
        gov.propose(block.timestamp + 1, block.timestamp + 2, 1, "any ipfs CID");
        vm.stopPrank();
    }

    function testRevertsOnProposeWhereStartIsInPast() public {
        addMember(bob);

        vm.startPrank(bob);
        vm.expectRevert("RoleBasedGovernance: startTime must be in the future or now");
        gov.propose(block.timestamp - 1, block.timestamp + 2, 1, "any ipfs CID");
        vm.stopPrank();
    }

    function testRevertsOnProposeWhereStartIsAfterEnd() public {
        addMember(bob);

        vm.startPrank(bob);
        vm.expectRevert("RoleBasedGovernance: startTime must be before endTime");
        gov.propose(block.timestamp + 3, block.timestamp + 2, 1, "any ipfs CID");
        vm.stopPrank();
    }

    function createProposalFromBob() internal returns (RoleBasedGovernance.Proposal memory proposal) {
        addMember(bob);

        vm.startPrank(bob);
        proposal = gov.propose(block.timestamp, block.timestamp + 2, 49, "any ipfs CID");
        vm.stopPrank();
    }

    function createProposalFromBobWithoutJoin() internal returns (RoleBasedGovernance.Proposal memory proposal) {
        vm.startPrank(bob);
        proposal = gov.propose(block.timestamp, block.timestamp + 2, 49, "any ipfs CID");
        vm.stopPrank();
    }

    function testVotes() public {
        RoleBasedGovernance.Proposal memory proposal = createProposalFromBob();

        addMember(alice);

        vm.startPrank(alice);
        vm.warp(block.timestamp + 1);
        gov.vote(proposal.id, true);
        vm.stopPrank();
    }

    function testVotesWithDifferentRoles() public {
        RoleBasedGovernance.Proposal memory proposal = createProposalFromBob();

        addMember(alice, RoleBasedGovernance.Roles.A);

        vm.startPrank(alice);
        vm.warp(block.timestamp + 1);
        gov.vote(proposal.id, true);
        vm.stopPrank();

        (RoleBasedGovernance.Proposal memory proposalAfterFirstVote,) = gov.getProposal(proposal.id);
        assertEq(proposalAfterFirstVote.voting, gov.ROLE_A_WEIGHT());

        addMember(carol, RoleBasedGovernance.Roles.B);

        vm.startPrank(carol);
        gov.vote(proposal.id, true);
        vm.stopPrank();

        (RoleBasedGovernance.Proposal memory proposalAfterSecondVote,) = gov.getProposal(proposal.id);
        assertEq(proposalAfterSecondVote.voting, proposalAfterFirstVote.voting + gov.ROLE_B_WEIGHT());

        addMember(dave, RoleBasedGovernance.Roles.C);

        vm.startPrank(dave);
        gov.vote(proposal.id, true);
        vm.stopPrank();

        (RoleBasedGovernance.Proposal memory proposalAfterThirdVote,) = gov.getProposal(proposal.id);
        assertEq(proposalAfterThirdVote.voting, proposalAfterSecondVote.voting + gov.ROLE_C_WEIGHT());
    }

    function testRevertsOnVoteBeforeStart() public {
        RoleBasedGovernance.Proposal memory proposal = createProposalFromBob();

        addMember(alice);

        vm.startPrank(alice);
        vm.expectRevert("RoleBasedGovernance: Voting has not started yet");
        gov.vote(proposal.id, true);
        vm.stopPrank();
    }

    function testRevertsOnVoteAfterEnd() public {
        RoleBasedGovernance.Proposal memory proposal = createProposalFromBob();

        addMember(alice);

        vm.startPrank(alice);
        vm.warp(block.timestamp + 2);
        vm.expectRevert("RoleBasedGovernance: Voting has ended");
        gov.vote(proposal.id, true);
        vm.stopPrank();
    }

    function testRevertsOnVoteAfterQuorumReached() public {
        RoleBasedGovernance.Proposal memory proposal = createProposalFromBob();

        addMember(alice, RoleBasedGovernance.Roles.A);

        vm.startPrank(alice);
        vm.warp(block.timestamp + 1);
        gov.vote(proposal.id, true);
        vm.stopPrank();

        addMember(carol, RoleBasedGovernance.Roles.B);

        vm.startPrank(carol);
        gov.vote(proposal.id, true);
        vm.stopPrank();

        addMember(dave, RoleBasedGovernance.Roles.C);

        vm.startPrank(dave);
        gov.vote(proposal.id, true);
        vm.stopPrank();

        addMember(eve, RoleBasedGovernance.Roles.A);

        vm.startPrank(eve);
        vm.expectRevert("RoleBasedGovernance: Quorum reached");
        gov.vote(proposal.id, true);
        vm.stopPrank();
    }

    function testActiveProposals() public {
        createProposalFromBob();
        createProposalFromBobWithoutJoin();
        createProposalFromBobWithoutJoin();

        uint256[] memory activeProposals = gov.getActiveProposalIDs();

        assertEq(activeProposals.length, 3);
    }

    function testRevertsOnDoubleJoin() public {
        addMember(bob);

        vm.startPrank(bob);
        vm.expectRevert("RoleBasedGovernance: Member already joined the DAO");
        gov.join();
        vm.stopPrank();
    }
}
