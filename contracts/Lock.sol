// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract Crowdfunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint goal;
        uint deadline;
        uint amountCollected;
        address[] donors;
        mapping(address => uint) donations;
    }

    uint public campaignCount = 0;
    mapping(uint => Campaign) public campaigns;

    event CampaignCreated(uint id, address indexed owner, uint goal, uint deadline);
    event DonationReceived(uint indexed id, address indexed donor, uint amount);

    function createCampaign(
        string memory _title,
        string memory _description,
        uint _goal,
        uint _deadline
    ) public returns (uint) {
        require(_deadline > block.timestamp, "Deadline must be in the future");

        campaignCount++;
        Campaign storage campaign = campaigns[campaignCount];

        campaign.owner = msg.sender;
        campaign.title = _title;
        campaign.description = _description;
        campaign.goal = _goal;
        campaign.deadline = _deadline;

        emit CampaignCreated(campaignCount, msg.sender, _goal, _deadline);

        return campaignCount;
    }

    function donateToCampaign(uint _id) public payable {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp < campaign.deadline, "Campaign has ended");
        require(msg.value > 0, "Donation must be greater than 0");

        campaign.donors.push(msg.sender);
        campaign.donations[msg.sender] += msg.value;
        campaign.amountCollected += msg.value;

        emit DonationReceived(_id, msg.sender, msg.value);
    }

    function getDonors(uint _id) public view returns (address[] memory) {
        return campaigns[_id].donors;
    }

    function getCampaign(uint _id) public view returns (
        address, string memory, string memory, uint, uint, uint, address[] memory
    ) {
        Campaign storage c = campaigns[_id];
        return (
            c.owner, c.title, c.description,
            c.goal, c.deadline, c.amountCollected,
            c.donors
        );
    }
    
}
