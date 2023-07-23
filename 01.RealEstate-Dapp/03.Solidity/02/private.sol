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
    function test() private {
        // ...
    }
}
contract YourContrat is MyContract {
    function callTest() public {
        // 상속 시 private 호출 시 오류
        //test();
    }
}

contract HisContrat {
    MyContract myContract;

    function callTest() public {
        // 객체 선언 시 private 호출 시 오류
        //myContract.test();
    }
}