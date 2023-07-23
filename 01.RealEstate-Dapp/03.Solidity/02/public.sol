// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract MyContract {    
    // 상태변수
    uint public count; 

    // 생성자
    constructor() {
        // ...
    }

    // 함수
    function numOfStudents(uint _teacher) public pure returns (uint) { 
        //test();
        return _teacher;
    }

    // 내부 또는 상속에서만 호출 가능
    function test() public {
        // ...
    }
}

contract YourContrat {
    MyContract myContract;

    function callTest() public {
        myContract.test();
    }
}