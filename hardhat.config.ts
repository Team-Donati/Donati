import { HardhatUserConfig } from "hardhat/config";
import * as dotenv from "dotenv";
import "@nomicfoundation/hardhat-toolbox";

dotenv.config();

// const DEFAULT_OPTIMIZER = {
//   version: "0.8.18",
//   settings: {
//     optimizer: {
//       enabled: true,
//       runs: 300,
//     },
//   },
// };

const config: HardhatUserConfig = {
  //solidity: "0.8.18",
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 2000,
        details: {
          yul: true,
          yulDetails: {
            stackAllocation: true,
            optimizerSteps: "dhfoDgvulfnTUtnIf",
          },
        },
      },
    },
  },
  networks: {
    devnet: {
      url: "http://aops-custom-202305-2crvsg-nlb-1d600174371701f9.elb.ap-northeast-2.amazonaws.com:9650/ext/bc/XpX1yGquejU5cma1qERzkHKDh4fsPKs4NttnS1tErigPzugx5/rpc",
      accounts: [process.env.DEPLOYER_ACCOUNT || "", process.env.TEST_DONATOR || ""],
    },
  },
};

export default config;
