const hre = require("hardhat");
const fs = require("fs");
const path = require("path");

async function main() {
  const Crowdfunding = await hre.ethers.getContractFactory("Crowdfunding");
  const crowdfunding = await Crowdfunding.deploy();

  await crowdfunding.deployed();

  // Ensure the directory exists
  const dirPath = path.join(__dirname, "../../frontend/src/blockchain");
  fs.mkdirSync(dirPath, { recursive: true });

  // Write contract address to frontend/src/blockchain/contract-address.json
  const addressData = { address: crowdfunding.address };
  fs.writeFileSync(
    path.join(dirPath, "contract-address.json"),
    JSON.stringify(addressData, null, 2)
  );

  console.log(`✅ Contract deployed to: ${crowdfunding.address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
