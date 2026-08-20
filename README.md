# ERC-20 Staking Project

A Solidity staking project built with Foundry and deployed to the Ethereum Sepolia testnet.

## Overview

This project implements:

- A custom ERC-20 token (`MyToken`)
- A staking contract (`Staking`)
- Time-based staking rewards
- ERC-20 allowance and transfer logic
- Staking and withdrawal events
- Foundry unit tests
- Sepolia testnet deployment and verification

## Tech Stack

- Solidity `^0.8.18`
- Foundry
- Ethereum Sepolia
- ERC-20
- Etherscan / Sourcify verification

## How It Works

Users first approve the `Staking` contract to spend their `MyToken`.

They can then stake tokens:

```text
User
  │
  │ approve()
  ▼
MyToken
  │
  │ stake()
  ▼
Staking Contract
  │
  │ time passes
  ▼
Reward accumulates
  │
  │ withdraw()
  ▼
User receives stake + reward
```

## Reward Calculation

The staking contract uses a 10% annual reward rate.

The reward is calculated from:

- Staked amount
- Time elapsed
- Annual reward rate

The contract calculates the reward dynamically using `block.timestamp`.

## Smart Contracts

### MyToken

Custom ERC-20 token used for staking.

### Staking

Handles:

- Depositing/staking tokens
- Tracking each user's stake
- Calculating rewards
- Withdrawing the original stake plus reward

## Project Structure

```text
staking-project/
├── src/
│   ├── MyToken.sol
│   └── Staking.sol
├── test/
│   ├── MyToken.t.sol
│   └── Staking.t.sol
├── script/
│   └── Deploy.s.sol
├── lib/
├── foundry.toml
└── README.md
```

## Testing

Tests were written with Foundry and cover token and staking behavior, including:

- Initial token supply
- Token transfers
- Insufficient balance handling
- Staking
- Multiple stakes
- Reward calculation
- Withdrawal
- Withdrawal events

Run the test suite with:

```bash
forge test
```

## Build

Compile the contracts with:

```bash
forge build
```

## Sepolia Deployment

The contracts were deployed to Ethereum Sepolia.

### MyToken

```text
0xfd539274af224b3c3d9873ee0c43040425b23fbe
```

[View MyToken on Sepolia Etherscan](https://sepolia.etherscan.io/address/0xfd539274af224b3c3d9873ee0c43040425b23fbe)

### Staking

```text
0x2c0a6646496a542282de5ad999b8572cb2a78b1c
```

[View Staking on Sepolia Etherscan](https://sepolia.etherscan.io/address/0x2c0a6646496a542282de5ad999b8572cb2a78b1c)

Both contracts were successfully deployed and verified.

## Deployment

The deployment script can be run with Foundry:

```bash
forge script script/Deploy.s.sol:Deploy   --rpc-url "$SEPOLIA_RPC_URL"   --private-key "$PRIVATE_KEY"   --broadcast
```

Keep private keys and API keys in `.env` and never commit them to GitHub.

## Example Interaction Flow

```text
1. Deploy MyToken
2. Deploy Staking
3. Approve Staking to spend MyToken
4. Stake tokens
5. Wait for rewards to accumulate
6. Check calculateReward()
7. Fund the staking contract with reward tokens
8. Withdraw stake + reward
```

## Security Notes

This project is intended for learning and testnet use.

It has not been audited and should not be used with real funds on mainnet without a professional security review.

## Future Improvements

Possible improvements include:

- Preventing a user from accidentally overwriting an existing stake
- Supporting multiple staking positions
- Adding an emergency withdrawal mechanism
- Adding a configurable reward pool
- Adding pause functionality
- Adding OpenZeppelin contracts
- Adding a frontend with React/Next.js
- Adding automated deployment and verification
- Adding stronger access control for reward funding

## Author

Sourin Dutta

Built as a hands-on Solidity and Foundry blockchain development project.
