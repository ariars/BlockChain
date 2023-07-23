// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract MyContract {
    // 상태 변수
    uint count; 

    // 생성자
    constructor() {
        // ...
    }

    // 함수
    function numOfStudents(uint _teacher) public pure returns (uint) { 
        return _teacher;
    }
}