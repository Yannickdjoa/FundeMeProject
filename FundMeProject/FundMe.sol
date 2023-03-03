//SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
import "./PriceConverter.sol";
//create a function allowing people to fund me with the possibility to withdraw the money. 
contract FundMe{
    using PriceConverter for uint256;
    uint256 public constant minimumUsd= 50*1e10; //minimum amount to fund
    address[] public funders;
    mapping(address=>uint256) public fundedAmountPerUser;
    address public immutable i_owner;


    constructor(){
        i_owner= msg.sender;
    }

    //2 separate functions 1 for Fund and the second for withdrawal
    function fund() public payable{
        //possibility to send a payment with a minimum amount
        require(msg.value.getConvertedRate()>= minimumUsd, "amount sent is not enough");
        funders.push(msg.sender);
        fundedAmountPerUser[msg.sender] +=msg.value;

    }


    function withdrawal() public onlyOwner{
        //set: 1. ability to withdraw 2.only owner can withdraw 3. set funders address and amount to zero after withdrawal
        //  3 ways how to withdraw from a contract (transfer, send, call)
        for(uint256 fundersIndex=0; fundersIndex< funders.length; fundersIndex++){
            address funder= funders[fundersIndex];
            fundedAmountPerUser[funder]=0; // setting funder amount to zero
            funders= new address[](0); //setting funders to zero 
        }
        (bool ethWithdrawn, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(ethWithdrawn, "You are not the owner");

    }
    modifier onlyOwner{
        require(msg.sender== i_owner, "You are not the owner");
        _;
    }
}