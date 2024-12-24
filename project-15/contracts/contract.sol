// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VolunteerHourTracker {

    // Define token properties
    uint256 public tokenRatePerHour = 1 * 10**18; // 1 token per hour (in wei)
    
    // Mapping to store hours worked by each volunteer
    mapping(address => uint256) public volunteerHours;
    // Mapping to store the total tokens earned by each volunteer
    mapping(address => uint256) public volunteerTokens;

    // ERC20-like variables (for simplicity, we assume the contract itself is the token)
    string public name = "VolunteerToken";
    string public symbol = "VLT";

    // Event to log when volunteer hours are logged
    event VolunteerHoursLogged(address indexed volunteer, uint256 hoursWorked);
    // Event to log when tokens are claimed
    event TokensClaimed(address indexed volunteer, uint256 tokensClaimed);

    // Function 1: Log Volunteer Hours and earn tokens
    function logVolunteerHours(uint256 hoursWorked) external {
        require(hoursWorked > 0, "Hours worked must be greater than zero");

        // Add the hours worked to the volunteer's total hours
        volunteerHours[msg.sender] += hoursWorked;

        // Calculate the tokens earned based on the hours worked
        uint256 tokensEarned = hoursWorked * tokenRatePerHour;

        // Update the volunteer's total earned tokens
        volunteerTokens[msg.sender] += tokensEarned;

        // Emit an event to log the hours worked
        emit VolunteerHoursLogged(msg.sender, hoursWorked);
    }

    // Function 2: Claim Tokens for logged volunteer hours
    function claimTokens() external {
        uint256 tokensToClaim = volunteerTokens[msg.sender];
        require(tokensToClaim > 0, "No tokens to claim");

        // Reset the volunteer's token balance after claiming
        volunteerTokens[msg.sender] = 0;

        // In a real implementation, you would transfer tokens to the volunteer here
        // For simplicity, we assume the contract itself is handling the token transfer
        payable(msg.sender).transfer(tokensToClaim);  // Transfer the tokens (as Ether for simplicity)

        // Emit an event to log the claim
        emit TokensClaimed(msg.sender, tokensToClaim);
    }

    // Function to fund the contract with tokens (or Ether in this case)
    receive() external payable {}
}
