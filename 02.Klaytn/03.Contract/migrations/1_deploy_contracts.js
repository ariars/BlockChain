var AdditionGame = artifacts.require("./AdditionGame.sol");

module.exports = function(deployer) {
  deployer.deploy(AdditionGame);
};
