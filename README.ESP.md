# 🏞️ Ayni Smart Contracts

Ayni es un **ecosistema de turismo Web3** diseñado para enriquecer la experiencia de viaje en Bolivia, fusionando su rica herencia cultural con la tecnología blockchain de **Mantle**. El proyecto crea un modelo de "Travel-to-Earn" donde los viajeros no solo exploran, sino que también contribuyen directamente a la preservación del patrimonio a través de la emisión de NFTs.

## ⚙️ Foundry

**Foundry** es un kit de herramientas de desarrollo de Ethereum increíblemente rápido, portátil y modular, escrito en Rust.

Foundry consiste en:

-   **Forge**: El framework de pruebas de Ethereum (similar a Truffle o Hardhat).
-   **Cast**: Una navaja suiza para interactuar con contratos inteligentes de EVM, enviar transacciones y obtener datos de la cadena.
-   **Anvil**: Un nodo de Ethereum local, ideal para desarrollo y pruebas.
-   **Chisel**: Un REPL de Solidity rápido y utilitario.

## 📚 Documentación

Puedes encontrar la documentación completa de Foundry aquí:
https://book.getfoundry.sh/

---

## 📜 Contratos Inteligentes

El ecosistema Ayni se construye sobre dos contratos inteligentes que se complementan para gestionar la lógica de "Travel-to-Earn".

### `AyniPasses.sol` (ERC-721)

Este contrato es el núcleo del modelo de negocio. Representa los **Pases de Ruta**, que son NFTs únicos (ERC-721) que otorgan acceso a los paquetes de viaje.

-   **`listRoute` 🗺️**: Permite a los operadores turísticos listar una nueva ruta, asociando un precio, un operador y metadatos del viaje.
-   **`buyPass` 💰**: La función que los turistas usan para adquirir un pase. Se realiza un pago con tokens **MNT** que se divide automáticamente en la blockchain: **85%** va al operador y **15%** a la tesorería del proyecto. Esta función está protegida contra reentradas para garantizar la seguridad.

### `AyniCommemorativeNFTs.sol` (ERC-1155)

Este contrato maneja los **NFTs Conmemorativos** que los turistas coleccionan. El uso de **ERC-1155** es altamente eficiente, permitiendo la acuñación de múltiples copias del mismo tipo de NFT a un costo muy bajo.

-   **`setTokenURI` ✨**: Permite al propietario del contrato definir la URI de los metadatos para cada tipo de NFT conmemorativo.
-   **`mint` ✅**: Acuña una copia del NFT para el turista. Esta función está protegida y es llamada por un servicio de backend seguro después de que el turista escanea un código QR en un punto de interés verificado.

---

## 🚀 Uso

### Cómo Empezar

1.  **Clona el Repositorio:**
    ```shell
    git clone [URL-DE-TU-REPOSITORIO]
    cd [NOMBRE-DE-TU-CARPETA]
    ```

2.  **Instala Dependencias:**
    ```shell
    forge install OpenZeppelin/openzeppelin-contracts@v5.0.0
    ```

### Comandos de Foundry

#### Construir 🏗️
Compila los contratos.
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
