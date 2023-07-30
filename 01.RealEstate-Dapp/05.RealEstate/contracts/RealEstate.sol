// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract RealEstate {
    struct Buyer {
        address buyerAddress;
        bytes32 name;
        uint age;
    }
    
    mapping(uint => Buyer) public buyerInfo;
    // 9862 에러로 코드 변환
    // address public owner;
    address payable public owner;
    address[10] public buyers;

    event LogBuyRealEstate(
        address _buyer,
        uint _id
    );

    constructor() {
        // 9862 에러로 코드 변환
        // owner = msg.sender;
        owner = payable(msg.sender);
    }

    function buyRealEstate(uint _id, bytes32 _name, uint _age) public payable {
        // 유효성 체크
        require(_id >= 0 && _id <= 9);
        buyers[_id] = msg.sender;
        buyerInfo[_id] = Buyer(msg.sender, _name, _age);
        
        owner.transfer(msg.value);
        emit LogBuyRealEstate(msg.sender, _id);
    }

function getBuyerInfo(uint _id) public view returns (address, bytes32, uint) {
    Buyer memory buyer = buyerInfo[_id];
    return (buyer.buyerAddress, buyer.name, buyer.age);
}

function getAllBuyers() public view returns (address[10] memory) {
    return buyers;
}
}