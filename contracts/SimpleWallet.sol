contract SimpleWallet {

	address owner;
	// mapping will allow us to determine if someone is allowed to send funds
	mapping(address => bool) isAllowedToSendFundsMapping; 


	// events for front-end display (note: underscores before variable names denote user input)
	event Deposit(address _sender, uint amount);
	event Withdrawal(address _sender, uint amount, address _beneficiary);

	// constructor function
	function SimpleWallet() {
		owner = msg.sender; //setting the owner as the wallet creator so we know who created the contract (good practice in order to avoid mishaps like outsiders claiming ownership and doing something like deleting the contract)
	}

	//an anonymous function is called when the contract receives some funds or is called without any funds but without any function
	//we look at whether the msg.sender is either the owner, or is allowed to deposit funds, and if so, we allow the tx to occur
	//just found out this is deprecated. consider refactoring to something like revert() or require() in the main sendFunds function
	function() {
		if(msg.sender == owner || isAllowedToSendFundsMapping[msg.sender] == true) {
			Deposit(msg.sender, msg.value); //emitting an event
		} else {
			throw;
		}
	}

	// the sendFunds() function takes an amount, as well as the recipient address. Only those allowed to send funds can call this function. That is, if they are either the owner, or in our created mapping. It returns the balance at the end of the function. 
	function sendFunds(uint amount, address beneficiary) returns (uint) {
		if(msg.sender == owner || isAllowedToSendFundsMapping[msg.sender]) {
			if(this.balance >= amount) {
				if(!beneficiary.send(amount)) {
					throw; //if for whatever reason, the beneficiery.send(amount) function does not work, we roll things back
				}
				Withdrawal(msg.sender, amount, beneficiary); //emitting an event
				return this.balance;
			}
		}
	}

	// here we add new validated addresses to our mapping. This can once again only be called by the owner.
	function allowAddressToSendMoney(address _address) {
		if (msg.sender == owner) {
			isAllowedToSendFundsMapping[_address] = true;
		}
	}

	//owner giveth, owner taketh away. pretty self explanatory.
	function disallowAddressToSendMoney(address _address) {
		if (msg.sender == owner) {
			isAllowedToSendFundsMapping[_address] = false;
		}
	}

	// a reader function to check if an address is allowed wallet access
	function isAllowedToSend(address _address) constant returns (bool) {
		return isAllowedToSendFundsMapping[_address] || _address == owner;
	}

	// self-destruct function that the owner can call which destroys the contract and deposits all remaining funds to the owner's wallet address
	function killWallet() {
		if(msg.sender == owner) {
			suicide(owner);
		}
	}


}