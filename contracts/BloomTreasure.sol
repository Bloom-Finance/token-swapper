// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract BloomTreasure {
    uint256 private balance;
    address private owner;
    mapping(address => uint256) private payersFees;

    constructor() {
        owner = msg.sender;
    }

    function fundTreasure() public payable {
        payersFees[msg.sender] += msg.value;
        balance += msg.value;
    }

    function getPublicBalance() public view returns (uint256) {
        return balance;
    }

    function retrieveBalance() public {
        require(msg.sender == owner, "Only the owner can retrieve the balance");
        payable(msg.sender).transfer(balance);
    }
}
