pragma solidity ^0.4.10;

contract Splitter {
	address public owner;
	address bob;
	address carol;
	bool carolNotPaid;
	bool bobNotPaid;
	mapping(address => uint) balances;

  event LogPayment(uint amount);
	event LogWithdrawal(uint amount);
	event LogFundsSplit(address first, address second, uint value);

	function Splitter() {
		owner = msg.sender;
	}

	function sendMoney(address address1, address address2) public payable returns(bool success) {
	  uint half = msg.value / 2;
	  uint remainder = msg.value % 2;
	  balances[address1] += half;
	  balances[address2] += half;
	  balances[msg.sender] += remainder;
	  LogFundsSplit(address1, address2, msg.value);
	  return true;
	}

	function getMyBalance() returns(uint) {
		return balances[msg.sender];
	}

	function getContractBalance() returns(uint) {
	    return this.balance;
	}

	function withdraw() public returns(bool) {
		  require(this.balance >= 0);
			if (balances[msg.sender] > 0) {
    	    msg.sender.transfer(balances[msg.sender]);
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
