const HDWalletProvider = require("truffle-hdwallet-provider-klaytn");
const NETWORK_ID = '1001'
const GASLIMIT = '8500000'
const URL = `https://public-en-baobab.klaytn.net`
const MNEMONIC = '{MNEMONIC}';
const privateKey = '{privateKey}';

module.exports = {
  networks: {  
    ganache: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "5778",
    },

    baobab: {
      provider: () => {
        return new HDWalletProvider(privateKey, "https://public-en-baobab.klaytn.net");
        //return new HDWalletProvider(MNEMONIC, "https://public-en-baobab.klaytn.net");
      },
      network_id: NETWORK_ID, //Klaytn baobab testnet's network id
      gas: GASLIMIT,
      gasPrice: null
    },

    // klaytn: {
    //   provider: new HDWalletProvider(PRIVATE_KEY, URL),
    //   network_id: NETWORK_ID,
    //   gas: GASLIMIT,
    //   gasPrice: null,
    // }  
  },
  mocha: {
    timeout: 100000
  },
  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.13",
    }
  },
};