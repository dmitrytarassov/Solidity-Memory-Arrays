// Right click on the script name and hit "Run" to execute
const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("MemoryArray", function () {
  let memoryArray;
  
  const program1 = "0x3877fbDe425d21f29F4cB3e739Cf75CDECf8EdCE";
  const program2 = "0x187F087EC07511A0D77EDA2cF6f137eE49d12389";
  const program1AccessLevel = 1;
  const program2AccessLevel = 2;
  let deployer;

  before(async function() {
    const MemoryArray = await ethers.getContractFactory("MemoryArray");
    memoryArray = await MemoryArray.deploy();
    await memoryArray.deployed();
    
    await memoryArray.addProgram(program1);
    await memoryArray.addProgram(program2);

    await memoryArray.setAccessLevel(program1, program1AccessLevel);
    await memoryArray.setAccessLevel(program2, program2AccessLevel);

    const [_deployer] = await ethers.getSigners();
    deployer = _deployer;
  });

  it("call correct method", async function() {
    const result = await memoryArray.getAccessLevel_CORRECT(deployer.address);

    expect(result[0].program).to.equal(program1);
    expect(result[1].program).to.equal(program2);

    expect(result[0].level.toString()).to.equal(program1AccessLevel.toString());
    expect(result[1].level.toString()).to.equal(program2AccessLevel.toString());
  });

  it("call wrong method", async function() {
    try {
      const result = await memoryArray.getAccessLevel_WRONG(deployer.address);

      expect(result[0].program).to.equal(program1);
      expect(result[1].program).to.equal(program2);

      expect(result[0].level.toString()).to.equal(program1AccessLevel.toString());
      expect(result[1].level.toString()).to.equal(program2AccessLevel.toString());
    } catch(e) {
      expect(e instanceof Error).to.equal(true);
      console.log(e);
    }
  });
});

describe("MemoryArray2", function () {
  let memoryArray;
  
  const program1 = "0x3877fbDe425d21f29F4cB3e739Cf75CDECf8EdCE";
  const program1AccessLevel = 1;
  let deployer;

  before(async function() {
    const MemoryArray = await ethers.getContractFactory("MemoryArray");
    memoryArray = await MemoryArray.deploy();
    await memoryArray.deployed();

    const [_deployer] = await ethers.getSigners();
    deployer = _deployer;
  });

  it("call correct method by steps", async function() {
    const result = await memoryArray.getAccessLevel_CORRECT(deployer.address);
    expect(result.length).to.equal(0);

    await memoryArray.addProgram(program1);
    const _result = await memoryArray.getAccessLevel_CORRECT(deployer.address);
    expect(_result.length).to.equal(0);

    await memoryArray.setAccessLevel(program1, program1AccessLevel);
    const __result = await memoryArray.getAccessLevel_CORRECT(deployer.address);
    expect(__result.length).to.equal(1);
    expect(__result[0].program).to.equal(program1);
    expect(__result[0].level.toString()).to.equal(program1AccessLevel.toString());
  });
});