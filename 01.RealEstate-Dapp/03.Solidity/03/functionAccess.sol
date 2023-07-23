// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;
contract MyContract {
    struct Student {
        string name;
        string gender;
        uint age;
    }

    mapping(uint256 => Student) studentInfo;

    function setStudentInfo(uint _studentId, string memory _name, string memory _gender, uint _age) public {
        Student storage student = studentInfo[_studentId];  // 키값으로 매개변수로 받은 _studentId (예: 1234) 입력
                                                            // 1234 값만의 특정 Student 구조체 정보를 불러온다
        // 각각 필드에 매개변수로 받은 자료형들 대입
        student.name = _name;
        student.gender = _gender;
        student.age = _age;
    }

    function getStudentInfo(uint256 _studentId) view public returns (string memory, string memory, uint) {
        // 매개변수로 받은 _studentId (예: 1234)를 키값으로 활용하여 1234값에 매핑된 value 값인 Student 를 불러온다
        return (studentInfo[_studentId].name, studentInfo[_studentId].gender, studentInfo[_studentId].age);
    }
}