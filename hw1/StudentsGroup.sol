pragma solidity ^0.8.7;

contract StudentsGroup {

    struct student {
        string name;
        uint age;
    }

    uint constant GROUPS_NUM = 4;
    student[] students;
    uint[] studentsToGroups;
    event studentWasAdded(string _name, uint age);

    function add_student(string memory _name, uint _age) public 
    {
        uint random_group = uint(keccak256(abi.encodePacked(_name))) % GROUPS_NUM;
        students.push(student(_name, _age));
        studentsToGroups.push(random_group);
        emit studentWasAdded(_name, _age);
    }

    function get_students_count() public view returns (uint) 
    {
        return students.length;
    }
}