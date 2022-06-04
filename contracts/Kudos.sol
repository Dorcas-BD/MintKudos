//SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract Kudos is ERC721Enumerable, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string public baseTokenURI;
    uint256 public immutable maxSupply;

    constructor(
        string memory name,
        string memory symbol,
        string memory _baseTokenURI, 
        uint256 _maxSupply
    ) ERC721(name, symbol) {
        require(_maxSupply > 0, "INVALID SUPPLY");
        baseTokenURI = _baseTokenURI;
        maxSupply = _maxSupply;

        _tokenIds.increment();
    }

    bool public isCourseCompleted = false;

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), ".json")) : "";
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        baseTokenURI = _newBaseURI;
    }

    function setCourseCompletedState(bool _courseCompletedState) public onlyOwner {
        isCourseCompleted = _courseCompletedState;
    }

    function mint() public payable virtual {
        require(isCourseCompleted, "Please complete the course");

        uint256 tokenId = _tokenIds.current();
        _safeMath(msg.sender, tokenId);
        _tokenIds.increment();

        if (totalSupply() + 1 >= maxSupply) {
            isCourseCompleted = false;
        }
    }

    function withdraw() external onlyOwner {
        payable((owner()).transfer(address(this).balance);
    }

}
