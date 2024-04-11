// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransactionAnalyzer {
    struct Transaction {
        uint amount;
        string category;
        uint timestamp;
    }
    mapping(uint => Transaction[]) private transactionsByMonth;
    mapping(address => uint) private userRewards;
    event TransactionAdded(address indexed user, uint indexed month, uint indexed amount, string category);
    event RewardsClaimed(address indexed user, uint rewards);
    function addTransaction(uint _amount, string memory _category) public {
        uint currentMonth = getCurrentMonth();
        Transaction memory newTransaction = Transaction(_amount, _category, block.timestamp);
        transactionsByMonth[currentMonth].push(newTransaction);
        emit TransactionAdded(msg.sender, currentMonth, _amount, _category);
    }
    function calculateRewards() public {
        uint currentMonth = getCurrentMonth();
        uint totalSavedAmount = 0;
        Transaction[] memory transactions = transactionsByMonth[currentMonth];
        for (uint i = 0; i < transactions.length; i++) {
            totalSavedAmount += transactions[i].amount;
        }
        uint rewards = totalSavedAmount / 1000 * 10; 
        userRewards[msg.sender] += rewards;
        emit RewardsClaimed(msg.sender, rewards);
    }
    function getTotalSpendingForCategory(uint _month, string memory _category) public view returns (uint) {
        uint totalSpending = 0;
        Transaction[] memory transactions = transactionsByMonth[_month];
        for (uint i = 0; i < transactions.length; i++) {
            if (keccak256(bytes(transactions[i].category)) == keccak256(bytes(_category))) {
                totalSpending += transactions[i].amount;
            }
        }
        return totalSpending;
    }
    function getCurrentMonth() private view returns (uint) {
        return (block.timestamp / 1 days / 30) + 1;
    }
    function checkRewards() public view returns (uint) {
        return userRewards[msg.sender];
    }
}
