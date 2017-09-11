pragma solidity ^0.4.10;

contract Splitter {
	address public owner;
	address bob;
	address carol;
	bool carolNotPaid;
	bool bobNotPaid;
	uint bobBalance;
	uint carolBalance;

  event LogPayment(uint amount);
	event LogWithdrawal(uint amount);

	function Splitter(address first, address second) {
		owner = msg.sender;
		bob = first;
		carol = second;
	}

	function sendMoney() payable returns(bool) {
		require(msg.sender == owner);
		uint balance = msg.value;
		LogPayment(balance);
		bobBalance += msg.value / 2;
		if (msg.value % 2 == 1) {
			carolBalance += msg.value / 2 + 1;
		} else {
			carolBalance += msg.value;
		}
		carolNotPaid = true;
		bobNotPaid = true;
		return true;
	}

	function getBobMoney() returns(uint) {
	    if (this.balance > 0) {
    	    return this.balance / 2;
	    }
	    return 0;
	}

	function getCarolMoney() returns(uint) {
	    if (this.balance <= 0) {
	        return 0;
	    }
	    else if (this.balance % 2 == 1) {
    	    return this.balance / 2 + 1;
	    }
	    return this.balance / 2;
	}

	function getContractBalance() returns(uint) {
	    return this.balance;
	}

	function withdraw() public returns(bool) {
		  require(this.balance >= 0);
			if (msg.sender == carol) {
					require(carolNotPaid);
					if (carolBalance > 0) {
						carolNotPaid = false;
	    	    carol.transfer(carolBalance);
						carolBalance = 0;
	    	    return true;
					}
	    }
			if (msg.sender == bob) {
					require(bobNotPaid);
					if (bobBalance > 0) {
						bobNotPaid = false;
	    	    bob.transfer(bobBalance);
						bobBalance = 0;
	    	    return true;
					}
	    }
	    return false;
	}

	function killContract() {
	    if(msg.sender == owner) {
	        suicide(owner);
	    }
	}
}
