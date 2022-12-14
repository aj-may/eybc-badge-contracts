// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/draft-ERC721Votes.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract EYBlockchainBadge is ERC721, ERC721Enumerable, ERC721Burnable, AccessControlEnumerable, EIP712, ERC721Votes {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    bytes32 public constant SYSTEM_ROLE = keccak256("SYSTEM_ROLE");

    constructor()
        ERC721("EY Blockchain Badge", "EYBB")
        EIP712("EY Blockchain Badge", "1")
    {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function contractURI() public pure returns (string memory) {
        return "https://badge.eybc.xyz/metadata/";
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://badge.eybc.xyz/metadata/";
    }

    function issue(address to) public onlyRole(SYSTEM_ROLE) {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    function revoke(uint256 tokenId) public onlyRole(SYSTEM_ROLE) {
        _burn(tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        require(from == address(0) || to == address(0), "ERC721Soulbound: token is non-transferable");
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _afterTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Votes)
    {
        super._afterTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, AccessControlEnumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
