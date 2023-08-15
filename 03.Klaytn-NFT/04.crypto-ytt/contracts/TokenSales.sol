// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./ERC721Full.sol";

contract TokenSales {

  ERC721Full public nftAddress;
  mapping (uint256 => uint256) public tokenPrice;

  event LogSetForSale(
        address _tokenOwner,
        address _this,
        address _sender
    );

  constructor(address _tokenAddress) {
    nftAddress = ERC721Full(_tokenAddress);
  }

  // 토큰 판매
  function setForSale(uint256 _tokenId, uint256 _price) public {

    address tokenOwner = nftAddress.ownerOf(_tokenId);

    emit LogSetForSale(tokenOwner, address(this), msg.sender);

    // 토큰 소유자만 판매  확인
    require(tokenOwner == msg.sender, "caller is not token owner");
    // 판매가격이 0보다 커야함
    require(_price > 0, "price is zero or lower");
    // 토큰 대리 판매 승인 여부 확인
    require(nftAddress.isApprovedForAll(tokenOwner, address(this)), "token owner did not approve TokenSales contract.");
    tokenPrice[_tokenId] = _price;
  }

  // 토큰 구매
  function purchaseToken(uint256 _tokenId) public payable {
    uint256 price  =tokenPrice[_tokenId];
    address tokenSeller = nftAddress.ownerOf(_tokenId);
    require(msg.value >= price, "celler sent klay lower than price"); 
    require(msg.sender != tokenSeller, "caller is token seller");
    payable(tokenSeller).transfer(msg.value);
    nftAddress.safeTransferFrom(tokenSeller, msg.sender, _tokenId);
    tokenPrice[_tokenId] = 0;
  }

  // 토큰 판매 삭제
  function removeTokenOnSale(uint256[] memory tokenIds) public {
    require(tokenIds.length > 0, "tokenIds is empty");
    for(uint i=0; i<tokenIds.length; i++) {
      uint256 tokenId = tokenIds[i];
      address tokenSeller = nftAddress.ownerOf(tokenId);
      require(msg.sender == tokenSeller, "caller is not token seller");
      tokenPrice[tokenId] = 0;
    }
  }
}