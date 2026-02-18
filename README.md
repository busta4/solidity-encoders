# ABI Encoder Demo

Solidity smart contract demonstrating the use of `abi.encodePacked` across common DeFi encoding patterns. Built with [Foundry](https://book.getfoundry.sh/).

## Overview

The `ABIEncoderDemo` contract showcases how `abi.encodePacked` is used in real-world DeFi scenarios to produce compact byte representations and deterministic hashes for on-chain data structures.

### Encoding Functions

| Function | Description |
|---|---|
| `createPoolIdentifier` | Generates a unique pool ID from a token pair and fee (tokens are sorted to ensure order-invariance) |
| `encodeTradingPosition` | Encodes a user's trading position with input/output tokens, amounts, and timestamp |
| `encodeSwapData` | Packs a multi-hop swap path, amounts, and deadline into a single byte array |
| `encodeLimitOrder` | Encodes a maker/taker limit order with a versioned tag (`LIMIT_ORDER_V1`) |
| `encodeYieldPosition` | Creates an identifier for a yield farming position |
| `encodeFlashLoanData` | Packs flash loan parameters including arbitrary callback data |
| `encodeStakingPoolConfig` | Encodes staking pool configuration (reward rate, lock period, max stakers) |
| `createUserMultiPoolHash` | Produces a unique hash for a user across multiple pools |
| `encodeYieldStrategy` | Encodes a named yield strategy with pools and weights |
| `encodeCrossChainBridgeData` | Packs cross-chain bridge transfer parameters |
| `createDeFiTransactionId` | Generates a unique DeFi transaction identifier |
| `encodeStopLossOrder` | Encodes a stop-loss order |
| `encodeTakeProfitOrder` | Encodes a take-profit order |
| `encodeTrailingStopOrder` | Encodes a trailing-stop order with activation price |

## Prerequisites

- [Foundry](https://getfoundry.sh/)

## Quick Start

```bash
# Install dependencies
forge install

# Build
forge build

# Run tests
forge test -vvv
```

## Project Structure

```
src/
  ABIEncoderDemo.sol    # Main contract with all encoding functions
test/
  ABIEncoderDemo.t.sol  # Tests covering pool IDs, trading positions, swap data, and reverts
```

## Author

Andres Bustamante
