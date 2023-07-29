var RealEstate = artifacts.require("./RealEstate.sol");

contract('RealEstate', function(accounts) { 
    var app;

    it("컨트랙의 소유자 초기화 테스팅", function(){
        return RealEstate.deployed().then(function(instance) { 
            app = instance;
            return app.owner.call();
        }).then(function(owner) {
            // assert.equal("리턴값", "예상값", "다를 경우 메시지")
            assert.equal(owner.toUpperCase(), accounts[0].toUpperCase(), "owner가 가나슈 첫번째 계정과 동일하지 않습니다.");
        });
    });
});