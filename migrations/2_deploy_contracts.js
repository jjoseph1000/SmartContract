var VoteToken = artifacts.require("./VoteToken.sol");
var VoteSession = artifacts.require("./VoteSession.sol");
var VotingToken = artifacts.require("./VotingToken.sol");
module.exports = function(deployer) {
  deployer.deploy(VoteToken);  
  deployer.deploy(VoteSession);
  deployer.deploy(VotingToken);
};
