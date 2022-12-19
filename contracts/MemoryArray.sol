// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract MemoryArray {
    struct AccessLevel {
        address program;
        uint8 level;
    }
    
    // user => (program => level)
    mapping(address => mapping(address => uint8)) accessLevels;
    address[] programs;

    function programExists(address program) public view returns(bool) {
        bool exists = false;

        for(uint256 i = 0; i < programs.length; i++) {
            if (programs[i] == program) {
                exists = true;
            }
        }

        return exists;
    }

    function addProgram(address program) public {
        if (!programExists(program)) {
            programs.push(program);
        }
    }

    function setAccessLevel(address program, uint8 level) public {
        require(programExists(program), "Unknown program");

        accessLevels[msg.sender][program] = level;
    }

    function getAccessLevel_WRONG(address user) public view returns(AccessLevel[] memory) {
        AccessLevel[] memory result;

        uint256 j = 0;

        for(uint256 i = 0; i < programs.length; i++) {
            address program = programs[i];
            uint8 accessLevel = accessLevels[user][program];

            if (accessLevel > 0) {
                result[j] = AccessLevel(
                    program,
                    accessLevel
                );
                j++;
            }
        }

        return result;
    }

    function getAccessLevel_CORRECT(address user) public view returns(AccessLevel[] memory) {
        uint256 length = 0;

        for(uint256 i = 0; i < programs.length; i++) {
            address program = programs[i];
            uint8 accessLevel = accessLevels[user][program];

            if (accessLevel > 0) {
                length++;
            }
        }

        AccessLevel[] memory result = new AccessLevel[](length);

        uint256 j = 0;

        for(uint256 i = 0; i < programs.length; i++) {
            address program = programs[i];
            uint8 accessLevel = accessLevels[user][program];

            if (accessLevel > 0) {
                result[j] = AccessLevel(
                    program,
                    accessLevel
                );
                j++;
            }
        }

        return result;
    }
}