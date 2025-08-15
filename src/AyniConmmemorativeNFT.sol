// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.4.0
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AyniCommemorativeNFTs is ERC1155, Ownable {
    // Mapeo para URIs de metadatos
    mapping(uint256 => string) private _tokenUris;
    
    // Eventos mejorados
    event TokenURIUpdated(uint256 indexed tokenId, string newUri);
    event CommemorativeNFTMinted(address indexed to, uint256 indexed tokenId, uint256 amount);

    /// @dev Constructor simplificado
    constructor(address initialOwner) 
        ERC1155("") 
        Ownable(initialOwner) 
    {}

    /// @dev Permite cambiar la URI de un token
    function setTokenURI(uint256 _tokenId, string memory _newUri) public onlyOwner {
        _tokenUris[_tokenId] = _newUri;
        emit TokenURIUpdated(_tokenId, _newUri);
    }

    /// @dev Función de acuñación mejorada
    function mint(address _to, uint256 _tokenId, uint256 _amount) public onlyOwner {
        require(bytes(_tokenUris[_tokenId]).length > 0, "URI no configurada para este token");
        _mint(_to, _tokenId, _amount, "");
        emit CommemorativeNFTMinted(_to, _tokenId, _amount);
    }

    /// @dev Batch mint para múltiples tokens
    function mintBatch(
        address _to,
        uint256[] memory _tokenIds,
        uint256[] memory _amounts
    ) public onlyOwner {
        for (uint i = 0; i < _tokenIds.length; i++) {
            require(bytes(_tokenUris[_tokenIds[i]]).length > 0, "URI no configurada para token");
        }
        _mintBatch(_to, _tokenIds, _amounts, "");
    }

    /// @dev Sobreescribe la función uri
    function uri(uint256 _tokenId) public view override returns (string memory) {
        require(bytes(_tokenUris[_tokenId]).length > 0, "Token no existe");
        return _tokenUris[_tokenId];
    }

    /// @dev Recupera la URI de un token sin validacións
    function getTokenURI(uint256 _tokenId) public view returns (string memory) {
        return _tokenUris[_tokenId];
    }
}