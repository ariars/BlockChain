// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./ERC721Full.sol";

contract YouTubeThumbnailToken is ERC721Full {

    constructor (string memory name_, string memory symbol_) ERC721Full(name_, symbol_) { }

    struct YouTubeThumbnail {
        string author;
        string dateCreated;
    }

    mapping (uint256 => YouTubeThumbnail) youTubeThumbnails;
    mapping (string => uint256) videoIdCreated;

    function mintYTT (string memory _videoId, string memory _author, string memory _dateCreated, string memory _tokenURI) public {
        require(videoIdCreated[_videoId] == 0, "videoId has already been created");

        // ERC721Enumerable totalSupply() 사용
        uint256 tokenId = totalSupply() + 1;
        youTubeThumbnails[tokenId] = YouTubeThumbnail(_author, _dateCreated);
        videoIdCreated[_videoId] = tokenId;

        // 다중 상속 시 여러 contract
        _mint(msg.sender, tokenId);

        // _tokenURI : ipfs 에 업로드된 주소
        // 토큰 발행
        _setTokenURI(tokenId, _tokenURI);
    }

    // 토큰 정보
    function getYTT(uint256 _tokenId) public view returns (string memory, string memory) {
        return (youTubeThumbnails[_tokenId].author, youTubeThumbnails[_tokenId].dateCreated);
    }

    // 사용중인 토큰인지 확인
    function isTokenAlreadyCreated(string memory _videoId) public view returns (bool) {
        return videoIdCreated[_videoId] != 0 ? true : false;
    }

    // function setApprovalForAllOwner(address owner, address operator, bool approved) public {
    //     super._setApprovalForAll(owner, operator, approved);
    // }
}