const hre = require("hardhat");

async function main() {
  // 1. Get the contract factory
  const HardwareMarketplace = await hre.ethers.getContractFactory("HardwareMarketplace");

  // 2. Deploy the contract
  const marketplace = await HardwareMarketplace.deploy();

  // 3. Wait for deployment to finish
  await marketplace.waitForDeployment();

  // 4. THIS IS YOUR DEPLOYED ADDRESS
  console.log("Contract deployed to:", await marketplace.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
