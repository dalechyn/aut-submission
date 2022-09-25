# Aut Submission

## Task
Requirements
Functionality 

Each Voting contract is associated with a single DAOExpander contract. Only a member of the DAO contract can deploy a voting contract for their DAO. 

Create a proposal with parameters - start time, end time and metadata CID that will be a JSON file stored on IPFS  holding the title, description etc for the proposal. 
The proposals are single choice voting - yes/no. Each proposal should have an identifier that is used as a reference. 
Vote - only members of the community can vote. Based on their role in the community their vote has different weight. 

Role 1 → A

Role 2 → B

Role 3 → C


In order to find the weight of each Role, solve the following series:

A. 
> Replace x with the correct number in the series:
6 - 12 - 8 - 14 - x - 16 | 6 * 2 = 12; 

```
6 - 12 - 8 - 14 - x - 16 | 6 * 2 = 12; 
6 * 2 - (2* 0) = 12;
8 * 2 - (2*1) = 16 - 2 = 14;
10 * 2 - (2*2) = 20 - 4 = 16;
```

Answer - 10

B. 
>Replace x with the correct number in the series:
1 - 2 - 6 - x - 88 - 445

```
I[1] = 1; // start
I[2] = i[1] * 1 + 1 = 2;
I[3] = i[2] * 2 + 2 = 6;
I[4] = i[3] * 3 + 3 = 21;
I[5] = i[4] * 4 + 4 = 88;
I[6] = i[5] * 5 + 5 = 445
```
Answer: 21

C. 
> Replace x with the correct number in the series:
3 - 9 - 6 - 11 - x - 14 - 72 - 18

```
For even = 9 + 2 -> 11, 11 + 3 -> 14, 14 + 4 -> 18
For odd: 3 * 2 -> 6, 6 * 3 -> 18, 6 * 4 -> 72
```

Answer: 18

## Setting up the repo
1. [Install](https://github.com/foundry-rs/foundry#installation) foundry;
2. Clone the repo;
3. Run `make install`;

## Coverage
Run `make coverage`.

```
Running tests...
+-----------------------------+-----------------+-----------------+----------------+---------------+
| File                        | % Lines         | % Statements    | % Branches     | % Funcs       |
+==================================================================================================+
| src/RoleBasedGovernance.sol | 100.00% (52/52) | 100.00% (58/58) | 50.00% (18/36) | 100.00% (7/7) |
|-----------------------------+-----------------+-----------------+----------------+---------------|
| Total                       | 100.00% (52/52) | 100.00% (58/58) | 50.00% (18/36) | 100.00% (7/7) |
+-----------------------------+-----------------+-----------------+----------------+---------------+
```

## Testing
The tests are run agains goerli fork.

In order to run tests yourself:

1. Create a `.env` file, and put `ALCHEMY_API_KEY` in order to run tests.
2. Run `make test` :)

## Implementation Description
`RoleBasedGovernance` is a simple Yes-No DAO.

In order to deploy and use one, you need to deploy `DAOExpander` via `DAOExpanderRegistry`, as roles are pulled from `AutID` contract.

Interfaces are split by files for better readability and are lying in `src/interfaces/`.

Aut-specific contracts are lying in `src/aut/`

## Docs
Could be generated with `solidity-docgen` along with `hardhat` but I did not want this repo to suffer from too much dependencies as it would made it harder to read & analyze.
