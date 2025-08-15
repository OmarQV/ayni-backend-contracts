// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.4.0
pragma solidity 0.8.27;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract AyniPasses is ERC721, Ownable, ReentrancyGuard {
    IERC20 public immutable MNT_TOKEN;
    address public ayniTreasury;
    uint256 private _nextTokenId;

    struct Route {
        address operator;
        uint256 priceInMNT;
        uint16 operatorFee;
        string uri;
    }

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

    function setAyniTreasury(address _newTreasury) public onlyOwner {
        ayniTreasury = _newTreasury;
    }

    function listRoute(uint256 _priceInMNT, string memory _routeUri) public {
        uint256 tokenId = _nextTokenId++;
        routeInfo[tokenId] = Route({
            operator: msg.sender,
            priceInMNT: _priceInMNT,
            operatorFee: 8500,
            uri: _routeUri
        });
        emit RouteListed(tokenId, msg.sender, _priceInMNT);
    }

    function buyPass(uint256 _routeId) public nonReentrant {
        Route storage route = routeInfo[_routeId];
        require(route.operator != address(0), "Ruta no existe");
        require(_ownerOf(_routeId) == address(0), "Pase ya vendido");

        uint256 price = route.priceInMNT;
        uint256 operatorAmount = (price * route.operatorFee) / 10000;
        uint256 ayniAmount = price - operatorAmount;

        require(MNT_TOKEN.transferFrom(msg.sender, address(this), price), "Transferencia fallida");
        require(MNT_TOKEN.transfer(route.operator, operatorAmount), "Pago a operador fallido");
        require(MNT_TOKEN.transfer(ayniTreasury, ayniAmount), "Pago a tesoreria fallido");

        _safeMint(msg.sender, _routeId);
        emit PassPurchased(_routeId, msg.sender);
    }

    function getRouteURI(uint256 tokenId) public view returns (string memory) {
        require(routeInfo[tokenId].operator != address(0), "Ruta no existe");
        return routeInfo[tokenId].uri;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_ownerOf(tokenId) != address(0), "Pase no comprado");
        return routeInfo[tokenId].uri;
    }

    function routeExists(uint256 tokenId) public view returns (bool) {
        return routeInfo[tokenId].operator != address(0);
    }
}