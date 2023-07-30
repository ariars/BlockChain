var RealEstate = artifacts.require("./RealEstate.sol");

contract('RealEstate', function(accounts) { 
    var app;

    it("컨트랙의 소유자 초기화 테스팅", function(){
        return RealEstate.deployed().then(function(instance) { 
            app = instance;
            return app.owner.call();
        }).then(function(owner) {
            assert.equal(owner.toUpperCase(), accounts[0].toUpperCase(), "owner가 가나슈 첫번째 계정과 동일하지 않습니다.");
        });
    });

    it("가나슈 두번째 계정으로 매물 아이디 0번 매입 후 이벤트 생성 및 매입자 정보와 buyers 배열 테스팅", function(){
        return RealEstate.deployed().then(function(instance) { 
            app = instance;
            return app.buyRealEstate(0, web3.utils.fromAscii("sjjeon"), 13, {from: accounts[1], value: web3.utils.toWei(String(0.10),'ether') });
        }).then(function(receipt) {
            assert.equal(receipt.logs.length, 1, "이벤트 하나가 생성되지 않았습니다.");
            assert.equal(receipt.logs[0].event, "LogBuyRealEstate", "이벤트가 LogBuyRealEstate 가 아닙니다.");
            assert.equal(receipt.logs[0].args._buyer.toUpperCase(), accounts[1].toUpperCase(), "매입자가 가나슈 두번째 계정이 아닙니다.");
            assert.equal(receipt.logs[0].args._id, 0, "매물 아이디가 0이 아닙니다.");
            return app.getBuyerInfo(0);
        }).then(function(buyerInfo) {
            assert.equal(buyerInfo[0].toUpperCase(), accounts[1].toUpperCase(), "매입자의 계정이 가나슈 두번째 계정과 일치하지 않습니다.");
            assert.equal(web3.utils.toAscii(buyerInfo[1]).replace(/\0/g, ''), "sjjeon", "매입자의 이름이 sjjeon 이 아닙니다.");
            assert.equal(buyerInfo[2], 13, "매입자의 나이가 13살이 아닙니다.");
            return app.getAllBuyers();
        }).then(function(buyers) {
            console.log (web3.utils.toAscii(buyers[1]));
            assert.equal(buyers[0].toUpperCase(), accounts[1].toUpperCase(), "buyers 배열 첫번째 인덱스의 계정이 가나슈 두번째 계정과 일치하지 않습니다.");
        });
    });
});