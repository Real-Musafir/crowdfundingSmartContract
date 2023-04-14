// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    // The owner of the crowdfunding campaign
    address public owner;

    // The name of the company
    string public companyName;

    // The total amount of shares issued by the company
    uint256 public totalShares;

    // The amount of ether required to buy one share
    uint256 public sharePrice;

    // The number of shares already sold
    uint256 public sharesSold;

    // The mapping of addresses to shares
    mapping(address => uint256) public shares;

    // The event that gets emitted when a new shareholder is added
    event ShareholderAdded(address indexed shareholder, uint256 shares);

    constructor(string memory _companyName, uint256 _totalShares, uint256 _sharePrice) {
        owner = msg.sender;
        companyName = _companyName;
        totalShares = _totalShares;
        sharePrice = _sharePrice;
    }

    // Function to buy shares
    function buyShares(uint256 _numShares) external payable {
        // Check that the campaign has not ended
        require(sharesSold < totalShares, "All shares have been sold");

        // Check that the correct amount of ether has been sent
        require(msg.value == _numShares * sharePrice, "Incorrect amount of ether sent");

        // Check that the buyer is not the owner
        require(msg.sender != owner, "Owner cannot buy shares");

        // Check that there are enough shares left to buy
        require(sharesSold + _numShares <= totalShares, "Not enough shares left");

        // Add shares to the buyer's account
        shares[msg.sender] += _numShares;

        // Increase the number of shares sold
        sharesSold += _numShares;

        // Emit the ShareholderAdded event
        emit ShareholderAdded(msg.sender, _numShares);
    }

    // Function to withdraw funds from the contract
    function withdrawFunds() external {
        // Check that the caller is the owner
        require(msg.sender == owner, "Only the owner can withdraw funds");

        // Transfer the contract balance to the owner's account
        payable(owner).transfer(address(this).balance);
    }
}
