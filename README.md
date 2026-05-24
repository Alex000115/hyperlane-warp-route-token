# Hyperlane Warp Route Template

In 2026, building inter-rollup applications requires customizable, developer-controlled cross-chain bridges rather than rigid third-party infrastructure. This repository provides a professional-grade implementation of a **Hyperlane Warp Route**. Warp Routes act as specific router contracts allowing any standard ERC-20 token to be transferred across chains by passing structured interchain messages.

## Operational Architecture
- **HypERC20 Collateral:** Deployed on the origin chain to lock incoming ERC-20 tokens.
- **HypERC20 Synthetic:** Deployed on the destination chain to mint corresponding synthetic representation tokens.
- **Interchain Security Modules (ISMs):** Fully customizable modular rules to verify cross-chain payloads securely before execution.

## Getting Started
1. Install core dependencies: `npm install`
2. Specify your network RPC end-points and keys inside `.env`.
3. Build and compile contracts: `npx hardhat compile`
4. Deploy warp routes: `node deployWarp.js`

## Technologies
- Solidity ^0.8.24
- Hyperlane Core SDK
- Hardhat / Ethers.js v6
