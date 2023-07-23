// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract MyContract {    
    // 상태변수(state variable)는 external 일 수 없다
    // uint external count; 
    uint count; 

    // 생성자
    constructor() {
        // ...
    }

    // 함수
    function numOfStudents(uint _teacher) public pure returns (uint) { 
        // test(); 외부에서만 호출 가능
        return _teacher;
    }

    // 외부에서만 호출 가능
    function test() external {
        // ...
    }
}

contract YourContrat {
    MyContract myContract;

    function callTest() public {
        myContract.test();
    }
}