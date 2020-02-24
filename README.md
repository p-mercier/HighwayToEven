## Presentation

This is a simple ethereum game for iOS devices.

The game is hosted on Ropsten so it doesn't require any real ether to play. [Link to the contract](https://ropsten.etherscan.io/address/0x91d423f9c9352ced88bdf71e82476c1bf7f195d7)

The iOS app was developed using the Ethereum API for Swift released by Argent Labs. [Link to the API](https://github.com/argentlabs/web3.swift).

The rules of the game are simple, when you tap the play button a number between 0 and 100 is generated, if the generated number is Even you win, if the number is Odd you lose.

At the start of the game, 0.01 Eth is sent to the smart contract from your account, if you win you get 0.02 back.

## Getting started

For the game to work you need to copy paste the private key of your Ropsten account and your Infura ID in Config.swift

## Disclaimer

This is a demo app that I did to test the Ethereum API for Swift made by Argent Labs, some shortcut have been taken in the code (for example for the private key storage). I think this demo project can help you discover the Ethereum API for Swift and Ethereum in general but I would not advise you to blindly use this code in an official app.
