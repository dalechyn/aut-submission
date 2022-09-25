//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IDAOExpanderFactory.sol";
import "./membershipCheckers/IDAOTypes.sol";
import "./membershipCheckers/IMembershipChecker.sol";

interface IDAOExpanderRegistry {
    function deployDAOExpander(
        uint256 daoType,
        address daoAddr,
        uint256 market,
        string calldata metadata,
        uint256 commitment
    )
        external
        returns (address _daoExpanderAddress);

    function getDAOExpanders() external view returns (address[] memory);

    function getDAOExpandersByDeployer(address deployer) external view returns (address[] memory);
}
