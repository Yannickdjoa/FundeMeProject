// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
//library for the price converter

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    //functions needed here are: 1. function to get the latest Price 2. function for version 3. function to get the rate convertion between USd to ETh

    
    function getLatestPrice() internal view returns(uint256){
        //ABI
        //contract 0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);

        (,int price,,,) = priceFeed.latestRoundData();
        return uint256(price*1e10);
    }
    function getVersion() internal view returns (uint256){
        // to get the latest version of the price
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e);
        return priceFeed.version();
    }
    function getConvertedRate(uint256 ethAmount) internal view returns(uint256){
        uint256 ethPrice= getLatestPrice();
        uint256 ethAmountInUsd= (ethPrice*ethAmount)/1e10;
        return ethAmountInUsd;

    }



}