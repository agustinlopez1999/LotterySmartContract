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

    //Events
    event buyingTokens(uint,address);

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
        emit buyingTokens(_tokenAmount,msg.sender);
    }

    //Returns balance of pool prize
    function poolPrize() public view returns (uint){
        return token.balanceOf(owner);
    }

    //Returns balance of sender
    function myTokensBalance() public view returns (uint){
        return token.balanceOf(msg.sender);
    }

    //Price of ticket
    uint public ticket_price = 2;

    //Mapping ddress who buys the tickets with ticket numbers
    mapping (address => uint []) id_address_ticket;
    //Mapping winner
    mapping (uint => address) random_number_address;
    //Random numbers
    uint randNonce = 0;
    //Array of Tickets
    uint [] buyed_tickets;
    //Events
    event event_ticket_purchased(uint,address);
    event event_ticket_winner(uint,address);

    //Function to buy lottery tickets
    function buyTicket(uint _tickets) public{
        uint cost = ticket_price*_tickets;
        require(cost <= myTokensBalance(),"Insufficient balance");
        token.transferFrom(msg.sender,owner,cost);
        for(uint i=0; i<_tickets; i++){
            uint random = uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,randNonce))) % 10000; //value between [0 - 9999]
            randNonce++;
            id_address_ticket[msg.sender].push(random);
            buyed_tickets.push(random);
            random_number_address[random] = msg.sender;
            emit event_ticket_purchased(random,msg.sender);
        }
    }

}