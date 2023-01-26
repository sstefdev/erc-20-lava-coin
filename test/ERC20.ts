import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers } from "hardhat";
import { ERC20 } from "../typechain-types";

describe("ERC20", function () {
  let erc20: ERC20;
  let someAddress: SignerWithAddress;
  let someOtherAddress: SignerWithAddress;

  beforeEach(async function () {
    const contract = await ethers.getContractFactory("ERC20");
    erc20 = await contract.deploy("Test", "TST");
    someAddress = (await ethers.getSigners())[1];
    someOtherAddress = (await ethers.getSigners())[2];
  });

  describe("when I have 10 tokens", function () {
    beforeEach(async function () {
      await erc20.transfer(someAddress.address, 10);
    });

    describe("when I transfer 10 tokens", () => {
      it("should transfer tokens correctly", async () => {
        await erc20.connect(someAddress).transfer(someOtherAddress.address, 10);
        expect(await erc20.balanceOf(someOtherAddress.address)).to.equal(10);
      });
    });

    describe("when I transfer 15 tokens", () => {
      it("should revert", async () => {
        await expect(
          erc20.connect(someAddress).transfer(someOtherAddress.address, 15)
        ).to.be.revertedWith("ERC20: transfer amount exceeds balance");
      });
    });
  });
});
