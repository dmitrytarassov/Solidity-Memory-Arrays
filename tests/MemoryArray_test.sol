// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "hardhat/console.sol";
import "remix_accounts.sol";
import "../contracts/MemoryArray.sol";

contract MemoryArrayTest {

    MemoryArray memoryArrayTest;
    address program1;
    address program2;

    uint8 program1AccessLevel = 1;
    uint8 program2AccessLevel = 2;

    function beforeAll () public {
        memoryArrayTest = new MemoryArray();

        program1 = TestsAccounts.getAccount(1);
        program2 = TestsAccounts.getAccount(2);

        memoryArrayTest.addProgram(program1);
        memoryArrayTest.addProgram(program2);

        memoryArrayTest.setAccessLevel(program1, program1AccessLevel);
        memoryArrayTest.setAccessLevel(program2, program2AccessLevel);
    }

    function callCorrectMethod() public {
        MemoryArray.AccessLevel[] memory levels = memoryArrayTest.getAccessLevel_CORRECT(address(this));
        Assert.equal(
            levels[0].program,
            program1,
            "Wrong program address"
        );

        Assert.equal(
            levels[0].level,
            program1AccessLevel,
            "Wrong access level"
        );

        Assert.equal(
            levels[1].program,
            program2,
            "Wrong program address"
        );

        Assert.equal(
            levels[1].level,
            program2AccessLevel,
            "Wrong access level"
        );
    }

    function callWrongMethod() public {
        MemoryArray.AccessLevel[] memory levels = memoryArrayTest.getAccessLevel_WRONG(address(this));
        Assert.equal(
            levels[0].program,
            program1,
            "Wrong program address"
        );

        Assert.equal(
            levels[0].level,
            program1AccessLevel,
            "Wrong access level"
        );

        Assert.equal(
            levels[1].program,
            program2,
            "Wrong program address"
        );

        Assert.equal(
            levels[1].level,
            program2AccessLevel,
            "Wrong access level"
        );
    }
}

contract MemoryArrayTest2 {

    MemoryArray memoryArrayTest;
    address program1;

    uint8 program1AccessLevel = 1;

    function beforeAll () public {
        memoryArrayTest = new MemoryArray();
    }

    function callCorrectMethodBySteps() public {
        MemoryArray.AccessLevel[] memory levels = memoryArrayTest.getAccessLevel_CORRECT(address(this));
        Assert.equal(
            levels.length,
            0,
            "Invalid array length"
        );
        
        program1 = TestsAccounts.getAccount(1);
        memoryArrayTest.addProgram(program1);
        MemoryArray.AccessLevel[] memory _levels = memoryArrayTest.getAccessLevel_CORRECT(address(this));
        Assert.equal(
            _levels.length,
            0,
            "Invalid array length"
        );

        memoryArrayTest.setAccessLevel(program1, program1AccessLevel);

        MemoryArray.AccessLevel[] memory __levels = memoryArrayTest.getAccessLevel_CORRECT(address(this));

        Assert.equal(
            __levels.length,
            1,
            "Invalid array length"
        );

        Assert.equal(
            __levels[0].program,
            program1,
            "Wrong program address"
        );

        Assert.equal(
            __levels[0].level,
            program1AccessLevel,
            "Wrong access level"
        );
    }
}
