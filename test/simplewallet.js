var SimpleWallet = artifacts.require("./SimpleWallet.sol");

contract('SimpleWallet', function(accounts) {

	it('should allow owners to send funds', function() {
		return SimpleWallet.deployed().then(function(instance) {
			//we call the function isAllowedToSend and pass in accounts[0] which is the account that called the contract
			return instance.isAllowedToSend.call(accounts[0]).then(function(isAllowed) {
				assert.equal(isAllowed, true, 'the owner should have been allowed to send funds');
			});
		});
	});

	it('should prevent other accounts from sending funds', function() {
		return SimpleWallet.deployed().then(function(instance) {
			return instance.isAllowedToSend.call(accounts[1]).then(function(isAllowed) {
				assert.equal(isAllowed, false, 'the other account was allowed to send funds');
			});
		});
	});

	it('should allow adding and removing of accounts to allowed list', function() {
		return SimpleWallet.deployed().then(function(instance){
			return instance.isAllowedToSend.call(accounts[1]).then(function(isAllowed) {
				assert.equal(isAllowed, false, 'the other account was allowed to send funds');
			}).then(function() {
				return instance.allowAddressToSendMoney(accounts[1]);
			}).then(function() {
				return instance.isAllowedToSend.call(accounts[1]).then(function(isAllowed) {
					assert.equal(isAllowed, true, 'the other account was still not allowed to send funds');
				}).then(function() {
					return instance.disallowAddressToSendMoney(accounts[1]);
				}).then(function() {
					return instance.isAllowedToSend.call(accounts[1]).then(function(isAllowed){
						assert.equal(isAllowed, false, 'the account was still allowed to send funds');
					});
				});
			});		
		});
	});

})

