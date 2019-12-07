import Web3 from 'web3'

if(!window.ethereum) {
    alert('Nem található a metamask kiegészítő. Kérlek telepítsd fel!')
}

window.web3 = new Web3(window.ethereum);

try {
    window.ethereum.enable()
    console.log('Metamask init success!')
}catch (e) {
    console.error('Metamask init failed')
    console.log(e)
}