const hre = require("hardhat");

async function main() {
  const Crowdfunding = await hre.ethers.getContractFactory("Crowdfunding");
  const crowdfunding = await Crowdfunding.deploy(); // deploy the contract

  await crowdfunding.waitForDeployment(); // ✅ works with Hardhat v2.17+
  console.log(`✅ Contract deployed to: ${crowdfunding.target}`); // use .target instead of .address
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
