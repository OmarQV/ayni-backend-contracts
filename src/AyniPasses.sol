// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.4.0
pragma solidity ^0.8.27;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721URIStorage} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract AyniPasses is ERC721, ERC721URIStorage, Ownable, ReentrancyGuard {
    // Dirección del token MNT en Mantle Sepolia Testnet
    IERC20 public immutable MNT_TOKEN;
    
    // Dirección de la tesorería del proyecto Ayni, que recibe las comisiones
    address public ayniTreasury;

    uint256 private _nextTokenId;

    // Estructura para almacenar información de cada ruta
    struct Route {
        address operator;
        uint256 priceInMNT;
        uint16 operatorFee; // Porcentaje del operador (85% = 8500)
    }

    // Mapeo del ID del token a los detalles de la ruta
    mapping(uint256 => Route) public routeInfo;

    event RouteListed(uint256 indexed routeId, address indexed operator, uint256 price);
    event PassPurchased(uint256 indexed routeId, address indexed buyer);

    constructor(address initialOwner, address mntTokenAddress)
        ERC721("Ayni Pass", "AYNIPASS")
        Ownable(initialOwner)
    {
        MNT_TOKEN = IERC20(mntTokenAddress);
        ayniTreasury = initialOwner;
    }
    
    /// @dev Permite al owner (futura DAO) cambiar la dirección de la tesorería.
    function setAyniTreasury(address _newTreasury) public onlyOwner {
        ayniTreasury = _newTreasury;
    }

    /// @dev Permite a un operador crear y listar una nueva ruta.
    /// @param _priceInMNT El precio del pase en tokens MNT.
    /// @param _routeUri La URI de los metadatos de la ruta, subida a Pinata.
    function listRoute(uint256 _priceInMNT, string memory _routeUri) public {
        uint256 tokenId = _nextTokenId++;
        
        routeInfo[tokenId] = Route({
            operator: msg.sender,
            priceInMNT: _priceInMNT,
            operatorFee: 8500 // 85% para el operador (8500 / 10000)
        });

        _setTokenURI(tokenId, _routeUri);
        
        emit RouteListed(tokenId, msg.sender, _priceInMNT);
    }

    /// @dev Permite a un turista comprar un pase de ruta.
    /// @param _routeId El ID de la ruta que se desea comprar.
    function buyPass(uint256 _routeId) public nonReentrant {
        Route storage route = routeInfo[_routeId];
        require(route.operator != address(0), "Route does not exist");
        require(ownerOf(_routeId) == address(0), "Pass has already been sold");

        // Calcular la comisión (15%) y la cantidad para el operador (85%)
        uint256 price = route.priceInMNT;
        uint256 operatorAmount = (price * route.operatorFee) / 10000;
        uint256 ayniAmount = price - operatorAmount;
        
        // El comprador debe haber aprobado la transferencia del token MNT
        require(MNT_TOKEN.transferFrom(msg.sender, address(this), price), "Token transfer failed");

        // Transferir los fondos automáticamente
        require(MNT_TOKEN.transfer(route.operator, operatorAmount), "Operator transfer failed");
        require(MNT_TOKEN.transfer(ayniTreasury, ayniAmount), "Treasury transfer failed");

        // Acuñar el NFT de pase al comprador
        _safeMint(msg.sender, _routeId);

        emit PassPurchased(_routeId, msg.sender);
    }

    // Las siguientes funciones son overrides requeridos por Solidity.
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    // El siguiente override es lo que causa el error. Lo corregiremos.
    // La función _update solo existe en ERC721.
    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721) // <-- ¡CORREGIDO!
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
