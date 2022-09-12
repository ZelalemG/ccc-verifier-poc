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


//TODO: create a function (Oracle gateway) to add merked tokens to the repository
//TODO: create a function to reverse the tokens to temporary vault & remove blocacklisted address
//TODO: create a function to verify that a token is clean
//TODO:
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableMap.sol";
import "@openzeppelin/contracts/security/PullPayment.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CoinVerifier is PullPayment {

  struct StollenToken {
        address token;
        address tokenOwner;
        uint tokenCount;
        address prevSender;
        uint256 transactionId;
        bool isBaseHolder;
    }
    
    mapping(address => StollenToken[]) public blackList;

    modifier onlyOwner() {
        if (msg.sender == owner) {            
            _;
        }
    }
    
    function addToBlackList(address _currentHolder, address _token, 
                            address _tokenOwner, uint tokenCount, 
                            address prevSender, uint256 transactionId) public {

        //TODO: require the caller to have oracle identifier
        if (mapping[_currentHolder] == address(0x0)) {
            blackList[_currentHolder].push(_token, );    
        } else {
            //TODO: Parse the address and update the mapping
        }        
    }  

    // ----- RETURNS TRUE ONLY IF ADDRESS IS CLEAN -----\\
    function varifyClearCoin(address _CCC_address, address _currentHolder, address _token) external returns (bool) {
         if (mapping[_currentHolder] != address(0x0)){
            return false;
         } else {
            //check if the identified token type is in archive then backtrack
            //TODO: create a function to trace back to specific time 
            return false;
         }         
    }

    function claimMyStolenToken() public {
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
