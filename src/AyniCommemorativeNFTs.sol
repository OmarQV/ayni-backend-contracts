// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.4.0
pragma solidity ^0.8.27;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract AyniCommemorativeNFTs is ERC1155, Ownable {
    
    // Mapeo para rastrear la URI de metadatos de cada tipo de NFT
    mapping(uint256 => string) private _tokenUris;

    event CommemorativeNFTMinted(address indexed to, uint256 indexed tokenId);

    /// @dev Constructor que define la URI genérica (opcional) y el owner.
    constructor(address initialOwner) ERC1155("") Ownable(initialOwner) {}

    /// @dev Permite al owner establecer la URI de metadatos para un tipo de NFT específico.
    /// @param _tokenId El ID del tipo de NFT (por ejemplo, el ID del punto de interés).
    /// @param _newUri La URI de los metadatos, subida a Pinata.
    function setTokenURI(uint256 _tokenId, string memory _newUri) public onlyOwner {
        _tokenUris[_tokenId] = _newUri;
    }
    
    /// @dev Permite a una entidad autorizada acuñar un NFT conmemorativo para un turista.
    /// @param _to La dirección del turista que recibirá el NFT.
    /// @param _tokenId El ID del tipo de NFT conmemorativo.
    function mint(address _to, uint256 _tokenId) public onlyOwner {
        // En una implementación más avanzada, podrías usar un rol específico
        // en lugar de onlyOwner para la acuñación.
        
        // Acuña una copia del NFT para el turista.
        _mint(_to, _tokenId, 1, "");

        emit CommemorativeNFTMinted(_to, _tokenId);
    }
    
    /// @dev Retorna la URI de los metadatos para un tipo de NFT.
    function uri(uint256 _tokenId) public view override returns (string memory) {
        return _tokenUris[_tokenId];
    }
}