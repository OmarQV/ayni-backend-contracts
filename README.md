# 🏞️ Ayni Smart Contracts

Ayni is a **Web3 tourism ecosystem** designed to enrich the travel experience in Bolivia, merging its rich cultural heritage with **Mantle** blockchain technology. The project creates a "Travel-to-Earn" model where travelers not only explore but also contribute directly to heritage preservation through the issuance of NFTs.

## ⚙️ Foundry

**Foundry** is a blazing-fast, portable, and modular toolkit for Ethereum application development, written in Rust.

Foundry consists of:

-   **Forge**: An Ethereum testing framework (similar to Truffle or Hardhat).
-   **Cast**: An EVM smart contract Swiss Army knife, for sending transactions and getting chain data.
-   **Anvil**: A local Ethereum node, ideal for development and testing.
-   **Chisel**: A fast and utilitarian Solidity REPL.

## 📚 Documentation

You can find the complete Foundry documentation here:
https://book.getfoundry.sh/

---

## 📜 Smart Contracts

The Ayni ecosystem is built on two complementary smart contracts that manage the "Travel-to-Earn" logic.

### `AyniPasses.sol` (ERC-721)

This contract is the core of the business model. It represents the **Route Passes**, which are unique NFTs (ERC-721) that grant access to travel packages.

-   **`listRoute` 🗺️**: Allows tourism operators to list a new route, associating a price, an operator, and travel metadata.
-   **`buyPass` 💰**: The function tourists use to purchase a pass. A payment in **MNT** tokens is automatically divided on the blockchain: **85%** goes to the operator, and the remaining **15%** goes to the project's treasury. This function is protected against reentrancy to ensure security.

### `AyniCommemorativeNFTs.sol` (ERC-1155)

This contract manages the **Commemorative NFTs** that tourists collect. Using **ERC-1155** is highly efficient, allowing for the minting of multiple copies of the same NFT type at a very low cost.

-   **`setTokenURI` ✨**: Allows the contract owner to define the metadata URI for each type of commemorative NFT.
-   **`mint` ✅**: Mints a copy of the NFT for the tourist. This function is protected and is called by a secure backend service after the tourist scans a QR code at a verified point of interest.

---

## 🚀 Usage

### Getting Started

1.  **Clone the Repository:**
    ```shell
    git clone [YOUR-REPO-URL]
    cd [YOUR-FOLDER-NAME]
    ```

2.  **Install Dependencies:**
    ```shell
    forge install OpenZeppelin/openzeppelin-contracts@v5.0.0
    ```

### Foundry Commands

#### Build 🏗️
Compiles the contracts.
```shell
$ forge build
```


## Documentation
## Probar ✅
## Ejecuta todas las pruebas en Solidity.

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```