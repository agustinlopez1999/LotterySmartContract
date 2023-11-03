// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "./ERC20.sol";

contract lottery{
    //Instance of Token Contract
    ERC20Basic private token;

    //Addresses
    address public owner;
    address public contract_address;

    //Token amount to create
    uint created_tokens = 10000;

    //Constructor
    constructor(){
        token = new ERC20Basic(created_tokens);
        owner = msg.sender;
        contract_address = address(this);
    }

    //Token price in Ethers
    function tokenPrice(uint _tokenAmount) internal pure returns(uint){
        return _tokenAmount * (1 ether);
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    //Mint more tokens for Lottery
    function mintTokens(uint _tokenAmount) public onlyOwner(){
        token.increaseTotalSupply(_tokenAmount);
    } 

    //Balance of remaining tokens in Lottery Library
    function availableTokens() public view returns(uint){
        return token.balanceOf(contract_address);
    }

    //Buy tokens
    function buyTokens(uint _tokenAmount) public payable{
        uint cost = tokenPrice(_tokenAmount);
        require(msg.value >= cost);
        uint returnValue = msg.value - cost;
        payable(msg.sender).transfer(returnValue);
        uint Balance = availableTokens();
        require(_tokenAmount <= Balance);
        token.transfer(msg.sender,_tokenAmount);
    }

    //Returns balance of pool prize
    function poolPrize() public view returns (uint){
        return token.balanceOf(owner);
    }

    //Returns balance of sender
    function myTokensBalance() public view returns (uint){
        return token.balanceOf(msg.sender);
    }

    

}