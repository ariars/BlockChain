// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

contract MyContract {
    struct Student {
        string name;
        string gender;
        uint age;
    }

    mapping(uint256 => Student) studentInfo;

    function setStudentInfo(uint _studentId, string memory _name, string memory _gender, uint _age) public {
        Student storage student = studentInfo[_studentId];

        student.name = _name;
        student.gender = _gender;
        student.age = _age;
    }

    function getStudentInfo(uint256 _studentId) view public returns (string memory, string memory, uint) {
        return (studentInfo[_studentId].name, studentInfo[_studentId].gender, studentInfo[_studentId].age);
    }
}