pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract baby_bank is ReentrancyGuard {
    mapping(address => uint256) public balance;
    mapping(address => uint256) public withdraw_time;
    mapping(address => bytes32) public user;

    constructor() payable {}

    function signup(string calldata _n) public {
        if (user[msg.sender] != 0) {
            return;
        }
        user[msg.sender] = keccak256(abi.encodePacked((_n)));
        withdraw_time[msg.sender] = (2**256) - 1;
    }

    function deposit() public payable {
        require(msg.value > 0, "Deposit amount must be greater than zero.");
        balance[msg.sender] += msg.value;
    }

    function withdraw() public nonReentrant {
        require(block.number >= withdraw_time[msg.sender]);
        require(balance[msg.sender] > 0);
        uint256 amountOfCallersBalance = balance[msg.sender]; // safely fetching the balance of the caller
        balance[msg.sender] = 0;
        
        (bool success, ) = msg.sender.call{value: amountOfCallersBalance}(""); // safely sending the balance to the caller
        require(success, "Transfer failed."); // if the transfer fails, revert the transaction
    }
}
