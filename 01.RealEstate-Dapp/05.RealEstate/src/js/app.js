App = {
  web3Provider: null,
  contracts: {},
  web3ProviderType: "",
  web3js:{},	
  init: function() {
    $.getJSON('../real-estate.json', function(data) {
      var list = $('#list');
      var template = $('#template');

      for(i = 0; i < data.length; i++) {
        template.find('img').attr('src', data[i].picture);
        template.find('.id').text(data[i].id);
        template.find('.type').text(data[i].type);
        template.find('.area').text(data[i].area);
        template.find('.price').text(data[i].price);

        list.append(template.html());
      }
    });

    return App.initWeb3();
  },

  initWeb3: function() {
    // // 브라우저에 Metamask 설치가 안되어 있는 경우 확인
    // // Metamask가 깔려있다면 Metamask의 web3 인스턴스를 브라우저에 미리 주입
    // if(typeof web3 !== 'undefined') {
    //   App.web3Provider = web3.currentProvider;
    // } else {
    //   // Metamask 가 없다면 Ganache의 web3 인스턴스를 가져옴
    //   App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    // }
    // web3 = new Web3(App.web3Provider);

    if (window.ethereum) {
      web3ProviderType = "metamask";
      App.web3Provider = window.ethereum;
      web3 = new Web3();
      try {
        // Request account access
        window.ethereum.enable();
      } catch (error) {
        // User denied account access...
        console.error("User denied account access")
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      web3ProviderType = "js";
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      web3ProviderType = "ganache";
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }

    return App.initContract();
  },

initContract: function() {
  // truffle-contract.js
  $.getJSON('RealEstate.json', function(data) {
    console.log(data);
    // Contract 인스턴스화
    App.contracts.RealEstate = TruffleContract(data);
    // 공급자 설정
    App.contracts.RealEstate.setProvider(App.web3Provider);
    App.listenToEvents();
  });
},

  buyRealEstate: function() {	
    var id = $('#id').val();
    var name = $('#name').val();
    var price = $('#price').val();
    var age = $('#age').val();

    ethereum.request({ method: 'eth_accounts' }).then(function(accounts) {
      
      var account = accounts[0];

      App.contracts.RealEstate.deployed().then(function(instance) {
        return instance.buyRealEstate(id, web3.utils.toHex(name), age, { from:account, value: price });
      }).then(function(){
        $('#name').val('');
        $('#age').val('');
        $('#buyModal').modal('hide');
      }).catch(function(err){
        console.log(err);
      });
      
    });
  },

  loadRealEstates: function() {
    App.contracts.RealEstate.deployed().then(function(instance){
      return instance.getAllBuyers.call();
    }).then(function(buyers){
      for(i = 0; i < buyers.length; i++) {
        if(buyers[i] != '0x0000000000000000000000000000000000000000'){
          var imgType = $('.panel-realEstate').eq(i).find('img').attr('src').substr(7);

          switch(imgType)
          {
            case 'apartment.jpg':
              $('.panel-realEstate').eq(i).find('img').attr('src', 'images/apartment_sold.jpg');
              break;

            case 'townhouse.jpg':
              $('.panel-realEstate').eq(i).find('img').attr('src', 'images/townhouse_sold.jpg');
              break;

            case 'house.jpg':
              $('.panel-realEstate').eq(i).find('img').attr('src', 'images/house_sold.jpg');
              break;
          }

          $('.panel-realEstate').eq(i).find('.btn-buy').text('매각').attr('disabled', true);
          $('.panel-realEstate').eq(i).find('.btn-buyerInfo').removeAttr('style');
        }        
      }
    }).catch(function(err){
      console.log(err.message);
    });
  },
	
  listenToEvents: function() {
    App.contracts.RealEstate.deployed().then(function(instance){

      App.loadRealEstates();

      instance.LogBuyRealEstate({fromBlock:0, toBlock:"latest"}, function(error, event){ 
        if(!error){
          $('#events').append('<p>' + event.args._buyer + ' 계정에서 ' + event.args._id + ' 번 매물을 매입했습니다.</p>')
        }
        else {
          console.error(error);
        }

        App.loadRealEstates();
      })
    }).then(function(buyerInfo){
      $(e.currentTarget).find('#buyerAddress').text(buyerInfo[0]);
      $(e.currentTarget).find('#buyerName').text(web3.utils.toUtf8(buyerInfo[1]));
      $(e.currentTarget).find('#buyerAge').text(buyerInfo[2]);
    }).catch(function(err){
      console.log(err.message);
    });
  }
};

$(function() {
  $(window).load(function() {
    App.init();
  });

  // 매입 Modal 이 띄워져 있다면 이벤트
  $('#buyModal').on('show.bs.modal', function(e) {
    var id = $(e.relatedTarget).parent().find('.id').text();
    var price;

    price = web3.utils.toWei(parseFloat($(e.relatedTarget).parent().find('.price').text() || 0), "ether");
    
    $(e.currentTarget).find('#id').val(id);
    $(e.currentTarget).find('#price').val(price);
  });


  $('#buyerInfoModal').on('show.bs.modal', function(e) {
    var id = $(e.relatedTarget).parent().find('.id').text();
    
    App.contracts.RealEstate.deployed().then(function(instance){
      return instance.getBuyerInfo.call(id);
    }).then(function(buyerInfo){
      $(e.currentTarget).find('#buyerAddress').text(buyerInfo[0]);
      $(e.currentTarget).find('#buyerName').text(web3.utils.toUtf8(buyerInfo[1]));
      $(e.currentTarget).find('#buyerAge').text(buyerInfo[2]);
    }).catch(function(err){
      console.log(err.message);
    });
  });
});
