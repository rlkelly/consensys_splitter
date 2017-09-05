pragma solidity ^0.4.10;

contract Splitter {
	address public owner;
	address bob;
	address carol;
	bool alreadyPaid;

  event LogPayment(uint amount);
	event LogWithdrawal(uint amount);

	function Splitter(address first, address second) {
		owner = msg.sender;
		bob = first;
		carol = second;
	}

	function sendMoney() payable returns(bool) {
		require(msg.sender == owner);
		LogPayment(msg.value);
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
			require(!alreadyPaid);
	    if (msg.sender == carol || msg.sender == bob) {
				  alreadyPaid = true;
				  LogWithdrawal(this.balance);
					uint bobBalance = getBobMoney();
					uint carolBalance = getCarolMoney();
    	    bob.transfer(bobBalance);
    	    carol.transfer(carolBalance);
    	    return true;
	    }
	    return false;
	}

	function killContract() {
	    if(msg.sender == owner) {
	        suicide(owner);
	    }
	}
}
