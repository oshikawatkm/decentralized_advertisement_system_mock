const Migrations = artifacts.require("./dad");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
};
