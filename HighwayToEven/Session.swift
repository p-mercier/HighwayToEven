//
//  Session.swift
//  HighwayToEven
//
//  Created by Philippe Mercier on 23/02/2020.
//  Copyright © 2020 Philippe Mercier. All rights reserved.
//

import web3

final class Session
{
    static let instance = Session()
    
    // Client
    public let client: EthereumClient?
    
    // Account
    public let account: EthereumAccount?
    
    // Contract
    public let contractAddress = EthereumAddress(Config.contractAddress)
    
    private init() {
        self.client = EthereumClient(url: URL(string: Config.clientUrl)!)
        self.account = try! EthereumAccount(keyStorage: CustomEthereumKeyStorage(privateKey: Config.privateKey))
    }
}
