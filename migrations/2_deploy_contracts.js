var VoteToken = artifacts.require("./VoteToken.sol");
var VoteSession = artifacts.require("./VoteSession.sol");
module.exports = function(deployer) {
  deployer.deploy(VoteToken);  
  deployer.deploy(VoteSession);
};
