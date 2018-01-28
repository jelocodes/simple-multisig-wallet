contract SimpleWallet {

	address owner;
	// mapping will allow us to determine if someone is allowed to send funds
	mapping(adress => bool) isAllowedToSendFundsMapping; 


	// events for front-end display (note: underscores before variable names denote user input)
	event Deposit(address _sender, uint amount);
	event Withdrawal(address _sender, uint amount, address _beneficiary);

	// constructor function
	function simpleWallet() {
		owner = msg.sender; //setting the owner as the wallet creator so we know who created the contract (good practice in order to avoid mishaps like outsiders claiming ownership and doing something like deleting the contract)
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
		return isAllowedToSendFundsMapping[_address] || msg.sender == owner;
	}

	// self-destruct function that the owner can call which destroys the contract and deposits all remaining funds to the owner's wallet address
	function killWallet() {
		if(msg.sender == owner) {
			suicide(owner);
		}
	}


}