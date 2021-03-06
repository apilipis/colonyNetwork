/*
  This file is part of The Colony Network.

  The Colony Network is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  The Colony Network is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with The Colony Network. If not, see <http://www.gnu.org/licenses/>.
*/

pragma solidity ^0.4.23;
pragma experimental "v0.5.0";

import "../lib/dappsys/auth.sol";
import "../lib/dappsys/roles.sol";
import "./Authority.sol";
import "./IColony.sol";
import "./EtherRouter.sol";
import "./Token.sol";


contract ColonyNetworkStorage is DSAuth {
  // Address of the Resolver contract used by EtherRouter for lookups and routing
  address resolver;
  // Number of colonies in the network
  uint256 colonyCount;
  // uint256 version number of the latest deployed Colony contract, used in creating new colonies
  uint256 currentColonyVersion;
  // TODO: We can probably do better than having three colony-related mappings
  mapping (uint256 => address) _coloniesIndex;
  mapping (bytes32 => address) _colonies;
  mapping (address => bool) _isColony;
  // Maps colony contract versions to respective resolvers
  mapping (uint256 => address) colonyVersionResolver;

  struct Skill {
    // total number of parent skills
    uint256 nParents;
    // total number of child skills
    uint256 nChildren;
    // array of `skill_id`s of parent skills starting from the 1st to `n`th, where `n` is an integer power of two larger than or equal to 1
    uint256[] parents;
    // array of `skill_id`s of all child skills
    uint256[] children;
    // `true` for a global skill reused across colonies or `false` for a skill mapped to a single colony's domain
    bool globalSkill;
  }
  // Contains all global and local skills in the network, mapping skillId to Skill. Where skillId is 1-based unique identofier
  mapping (uint256 => Skill) skills;
  // Number of skills in the network, including both global and local skills
  uint256 skillCount;
  // skillId of the root global skills tree
  uint256 rootGlobalSkillId;

  struct ReputationLogEntry {
    address user;
    int amount;
    uint256 skillId;
    address colony;
    uint256 nUpdates;
    uint256 nPreviousUpdates;
  }

  mapping (uint => ReputationLogEntry[]) reputationUpdateLogs;
  // Tracks whether updateLog 0 or 1 is the active log
  uint256 activeReputationUpdateLog;
  // Address of the currently active reputation mining cycle contract
  address reputationMiningCycle;
    // The reputation root hash of the reputation state tree accepted at the end of the last completed update cycle
  bytes32 reputationRootHash;
  // The number of nodes in the reputation state tree that was accepted at the end of the last mining cycle
  uint256 reputationRootHashNNodes;
  // Mapping containing how much has been staked by each user
  mapping (address => uint) stakedBalances;
}
