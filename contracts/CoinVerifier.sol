//SPDX-License-Identifier: LICENSED
//NOTICE: This project is copyright protected!
pragma solidity ^0.8.9;

/*
@title CCC-Initiative
@author Zelalem Gebrekirstos
@notice This project is an ongoing research project, developed as a POC for a specific 
element of the CCC-Initiative project.
@Notice You may read a details of the project in my website at http://zillo.one/
or reach me out via info@zillo.one
*/

//TODO: Create a repository for the details of marked tokens
//TODO: create a function (Oracle gateway) to add merked tokens to the repository 
//TODO: create a function to reverse the tokens to temporary vault & remove blocacklisted address
//TODO: create a function to verify that a token is clean
//TODO: 
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import "@openzeppelin/contracts/security/PullPayment.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CoinVerifier is PullPayment {
    string campainName;
    address owner;
    uint minimumDonation;
    uint targetFund;
    bool campainIsActive;
    uint totalFund;

    address[] donators;
    mapping(address => uint) donations;

    /*  you can also alteratively use enumerable maps from openzeppelin 
        to manage donators such as get No. of donators...like below

        using EnumerableMap for EnumerableMap.AddressToUintMap;
        EnumerableMap.AddressToUintMap public donators;
    */

    function init(
        string memory _campaignName,
        uint _minDonation,
        uint _targetFund
    ) external {
        owner = msg.sender;
        campainName = _campaignName;
        minimumDonation = _minDonation;
        targetFund = _targetFund;
    }

    modifier onlyOwner() {
        if (msg.sender == owner) {
            _;
        }
    }

    function makeDonation() external payable {
        uint _amount = msg.value;
        require(campainIsActive, "Campaign not currently active");
        require(
            _amount >= minimumDonation,
            string(abi.encodePacked("Minimum donation is ", minimumDonation))
        );
        donations[msg.sender] = _amount;
        totalFund += _amount;
        donators.push(msg.sender);

        //close campain if target is reached\\
        if (address(this).balance >= targetFund) {
            campainIsActive = false;
        }
    }

    function withdraw() public onlyOwner {
        require(!campainIsActive, "Campaign not closed yet");
        require(
            address(this).balance > minimumDonation,
            "insufficient balance"
        );

        //using the asyncTransfer func from openzeppelin PullPayment
        //contract is safer as its stored in an intermediate Escrow contract
        _asyncTransfer(owner, totalFund);
        console.log("Funds delivered to owner. Amount = %s", totalFund);
        console.log("Funds delivered to owner. Amount = %s", totalFund);
    }

    function closeCampaign() external onlyOwner {
        campainIsActive = false;
        console.log("Campaign cancelled by owner!");
    }

    function checkCampaignStatus()
        public
        view
        onlyOwner
        returns (string memory _status)
    {
        if (campainIsActive) {
            _status = "Active";
        }
        return _status = "Closed";
    }
}
