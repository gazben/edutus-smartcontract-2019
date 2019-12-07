<template>
  <div id="app">
      <ul>
        <li :key="auction.address" v-for="auction in auctions">{{ auction.address }}</li>  
      </ul>
  </div>
</template>

<script>
// import web3 from '../contracts/web3'
import Auction from '../contracts/abi/Auction'
import AuctionHouse from '../contracts/abi/AuctionHouse'

export default {
  name: 'app',
  components: {},
  data() {
    return {
      auctions: [],
    }
  },
  beforeMount() {
    AuctionHouse.methods.getAuctions().call().then((auctions) => {
      this.auctions = auctions.map((address) => {
        console.log('Getting new auction: ' + address);

        Auction(address).methods.title().call().then((title) => {
          console.log('Title: ' + title);
        });

        return {
          address: address,
          auction: Auction(address),
          title: ""
        }
      })
    });
  }
}
</script>