// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

contract MyContract {
struct Student {
    uint studentId;
    string name;
}

mapping(uint256 => Student) studentInfo;

function updateStudentById(uint _studentId, string memory _name) public {
    Student storage student = studentInfo[_studentId];
    student.name = _name;
}
}