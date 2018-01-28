contract SimpleWallet {

	address owner;
	// mapping will allow us to determine if someone is allowed to send funds
	mapping(adress => bool) isAllowedToSendFundsMapping; 


	// events for front-end display (note: underscores before variable names denote user input)
	event Deposit(address _sender, uint amount);
	event Withdrawal(address _sender, uint amount, address _beneficiary);

	// constructor function
	function simpleWallet() {
		owner = msg.sender; //setting the owner as the wallet creator (good practice in order to avoid mishaps like outsiders deleting the contract)
	}
}