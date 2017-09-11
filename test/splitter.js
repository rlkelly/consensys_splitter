var Splitter = artifacts.require("./Splitter.sol");

contract('Splitter', function(accounts) {
  var instance;
  var alice = accounts[0];
  var bob = accounts[1];
  var carol = accounts[2];

  beforeEach(function (done) {
    Splitter.new({from: alice})
    .then(function (_instance) {
      instance = _instance;
    }).then(() => done());
  });

  it("should init with no balance", function() {
    return instance.getContractBalance.call().then(function(balance) {
      assert.equal(balance.valueOf(), 0, "started with positive balance");
    });
  });

  it("allow deposit from owner", function() {
    return instance.sendMoney(bob, carol, {from: alice, value: 100}).then(function() {
      return instance.getContractBalance.call().then(function(balance) {
        assert.equal(balance.valueOf(), 100, "balance is zero");
      });
    });
  });

  it("don't allow deposit from other users", function() {
    return instance.sendMoney({from: bob, value: 1000}).then(function() {
    })
    .then(assert.fail)
    .catch(() => {
      return instance.getContractBalance.call().then(function(balance) {
        return assert.equal(balance.valueOf(), 0, "balance is zero");
      });
    });
  });

  it("should have bob and carols total equal balance", function() {
    return instance.sendMoney(bob, carol, {from: alice, value: 101}).then(function() {
      return instance.getMyBalance({from: bob}).then(function(balance) {
        var bobBalance = balance;
        return instance.getMyBalance({from: carol}).then(function(balance){
          var carolBalance = balance;
        })
        return assert.equal(carolBalance + bobBalance, 101);
      });
    });
  });

  it("withdraw should remove my balance from total", function() {
    return instance.sendMoney(bob, carol, {from: alice, value: 101}).then(function() {
      instance.withdraw({from: carol}).then(function() {
        return instance.getContractBalance.call().then(function(balance) {
          return assert.equal(balance.valueOf(), 51, "balance is zero");
        });
      });
    });
  });

  it("owner suicide contract", () => {
    return instance.killContract({from: alice}).then(() => {
      return web3.eth.getCode(instance.address);
    }).then((response)=>{
      return assert.equal(response, "0x0", "instance did not die");
    })
  });

  it("non owner suicide contract", () => {
    var currentAddress = web3.eth.getCode(instance.address);
    return instance.killContract({from: bob}).then(() => {
      return web3.eth.getCode(instance.address);
    }).then((response)=>{
      return assert.equal(response, currentAddress, "instance died");
    })
  });

});
