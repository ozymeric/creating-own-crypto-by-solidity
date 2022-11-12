// SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.7.0 <0.9.0;

// now we will create a contract which will enable us to create and mint our own crypto currency.


contract MyCrypto {

    // we create the owner and the minter as well of our crypto. 
    address public minter;

    // and we also will need the address and amount pairings to be able to send or recieve cryptos. 
    mapping(address => uint) public balances; // this balances mapping will work as a list of addresses and their amounts.
    // we create here an event in order for our clients to get information about the transactions. 
    event Sent(address _from, address _to, uint _amount);
    // this event will create a mesasge on the terminal to tell the client "who" sent cryptos "to whom" and "how many". 
    
    // we also need this clearly ;)
    modifier onlyMinter {
        require(msg.sender == minter);
        _;
    } 

    // this is very basic. 
    constructor() {
        minter = msg.sender; 
    }

    // now we create a function to mint our coin.
    // as the minter we will determine an address and an amount to send our coin. 
    // only we as the minter are available to do this. 
    // other clients or nodes are not able to create our coin out of nowhere. Only we can mint and send it!!!
    function mint(address _receiver, uint _mintAmount) public onlyMinter {
        balances[_receiver] += _mintAmount;        
    }

    // we will predetermine an error message here in order to use it later by calling it. 
    // when the amount which wanted to be sent is bigger than the balance this error will occur. 
    error insufficientBalance(uint requested, uint available);

    // now let's send a certain amount of coins to a specific address
    // this function will be open and available for everyone who wants to send coins to other accounts. 
    // only if they have enough balance to do so1!!! 
    // we provide this check by require method or by using an if statement. Both examples are shown below:
    function send(address _receiver, uint _amount) public {
        // _________________________first way of doing this:
        /*
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] -= _amount;
        balances[_receiver] += _amount;
        */
        
        // _________________________Second way of doing this:
        // here we'll use the error we have created previously by revert keyword. 
        if (_amount > balances[msg.sender])
        // this works too:
        // revert insufficientBalance(_amount, balances[msg.sender]); 
        revert insufficientBalance({
            requested: _amount, 
            available: balances[msg.sender]
            }); // and this is another way of doing the same thing.
        balances[msg.sender] -= _amount;
        balances[_receiver] += _amount;
        emit Sent (msg.sender, _receiver, _amount); //when everything is alright and the send procedure has happened 
        //successfully, we use emit key to call and inform our clients about the transaction details.   
    }
}
