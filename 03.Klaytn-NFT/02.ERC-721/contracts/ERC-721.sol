// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.24 <0.9.0;

interface ERC721 {
    // event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
    // event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
    // event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    function balanceOf(address _owner) external view returns (uint256);
    function ownerOf(uint256 _tokenId) external view returns (address);
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) external;
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) external;
    function transferFrom(address _from, address _to, uint256 _tokenId) external;
    function approve(address _approved, uint256 _tokenId) external;
    function setApprovalForAll(address _operator, bool _approved) external;
    function getApproved(uint256 _tokenId) external view returns (address);
    function isApprovedForAll(address _owner, address _operator) external view returns (bool);
}

interface ERC721TokenReceiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes memory _data) external returns(bytes4);
}

interface ERC165 {
    function supportsInterface(bytes4 interfaceID) external view returns (bool);
}

contract ERC721Implementation is ERC721 {

    mapping (uint256 => address) tokenOwner;
    mapping (address => uint256) ownedTokensCount;
    mapping (uint256 => address) tokenApprovals;
    mapping (address => mapping (address => bool)) operatorApprovals;
    mapping (bytes4 => bool) supportedInterfaces;

    event eventLogging(address _sender, address _owner, address _approve);

    constructor() {
        supportedInterfaces[0x80ac58cd] = true;
    }

    // 토큰 발행
    function mint(address _to, uint _tokenId) public {
        tokenOwner[_tokenId] = _to;
        ownedTokensCount[_to] += 1;
    }

    // _owner 계정이 소유한 토큰의 총 개수
    function balanceOf(address _owner) public view returns (uint256) {
        return ownedTokensCount[_owner];
    }

    // _tokenId 토큰의 소유자를 확인
    function ownerOf(uint256 _tokenId) public view returns (address) {
        return tokenOwner[_tokenId];
    }

    // 토큰 다른 계정으로 이전
    // 토큰 아이디를 소유하고 있는 _from 계정에서 _to 계정으로 이전
    function transferFrom(address _from, address _to, uint256 _tokenId) public {
        // msg.sender : 0x9d27b3015100c5320715804ccc2da3af25a677dd
        // owner : 0xe0c1ea43ce40E080B6E377883a726680cb37e532
        // approved : 0x9d27B3015100c5320715804cCC2da3af25a677dD

        address owner = ownerOf(_tokenId);
        address approve = getApproved(_tokenId);

        emit eventLogging(msg.sender, owner, approve);

        // 함수 호출 계정과 owner 계정 비교
        require(msg.sender == owner || msg.sender == approve || isApprovedForAll(owner, msg.sender));
        // 계정 체크
        require(_from != address(0));
        require(_to != address(0));

        tokenOwner[_tokenId] = address(0);
        tokenOwner[_tokenId] = _to;

        if(ownedTokensCount[_from] != 0) {
            ownedTokensCount[_from] -= 1;
        }
        
        ownedTokensCount[_to] += 1;
    }

    // 토큰 다른 계정으로 이전
    // _to 계정 확인
    function safeTransferFrom(address _from, address _to, uint256 _tokenId) public {
        transferFrom(_from, _to, _tokenId);

        if(isContract(_to)) {
            bytes4 returnValue = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, '');
            require(returnValue == 0x150b7a02);
        }
    }

    // data parameter 추가
    function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes memory data) public {
        transferFrom(_from, _to, _tokenId);

        if(isContract(_to)) {
            bytes4 returnValue = ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, data);
            require(returnValue == 0x150b7a02);
        }
    }

    // 토큰 승인
    function approve(address _approved, uint256 _tokenId) public {
        address owner = ownerOf(_tokenId);
        require(_approved != owner);
        require(msg.sender == owner);
        tokenApprovals[_tokenId] = _approved;
    }

    // 토큰 승인 
    function getApproved(uint256 _tokenId) public view returns (address) {
        return tokenApprovals[_tokenId];
    }

    // msg.sender 계정이 _operator 계정에게 권한 부여
    function setApprovalForAll(address _operator, bool _approved) public {
        require(_operator != msg.sender);
        operatorApprovals[msg.sender][_operator] = _approved;
    }

    // _owner 계정이 _operator 계정에게 권한을 줬는지 확인
    function isApprovedForAll(address _owner, address _operator) public view returns (bool) {
        return operatorApprovals[_owner][_operator];
    }

function supportsInterface(bytes4 interfaceID) public view returns (bool) {
    return supportedInterfaces[interfaceID];
}

    // Contract 계정 확인
    function isContract(address _addr) private view returns (bool) {
        uint256 size;
        assembly { size:= extcodesize(_addr) }
        return size > 0;
    }
}

contract Auction is ERC721TokenReceiver {
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes memory _data) public returns(bytes4) {
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }

    function checkSupportsInterface(address _to, bytes4 interfaceID) public view returns (bool) {
        return ERC721Implementation(_to).supportsInterface(interfaceID);
    }
}