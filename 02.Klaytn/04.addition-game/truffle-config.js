const HDWalletProvider = require("truffle-hdwallet-provider-klaytn");
const MNEMONIC = 'original garage hurt forum present side reflect initial artwork harvest enjoy ritual';
const privateKey = "0x1d810b2581d7672975454bda8b1e2ec0d9fd7bf233ab5b8483cfc0537d626a0f";

module.exports = {
  networks: {
    baobab_mnemonic: {
      provider: () => {
        return new HDWalletProvider(MNEMONIC, "https://public-en-baobab.klaytn.net");
      },
      network_id: '1001', //Klaytn baobab testnet's network id
      gas: '8500000',
      gasPrice: null
    },
    baobab: {
      provider: () => {
        return new HDWalletProvider(privateKey, "https://public-en-baobab.klaytn.net");
      },
      network_id: '1001', //Klaytn baobab testnet's network id
      gas: '8500000',
      gasPrice: null
    },
  },

  mocha: {
    // timeout: 100000
  },

  // Configure your compilers
  compilers: {
    solc: {
      version: "0.8.13",
    }
  },
};