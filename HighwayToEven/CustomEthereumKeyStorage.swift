//
//  CustomEthereumKeyStorage.swift
//  HighwayToEven
//
//  Created by Philippe Mercier on 23/02/2020.
//

import web3

class CustomEthereumKeyStorage : EthereumKeyStorageProtocol {
    
    private var privateKey: String
    
    init(privateKey: String) {
        self.privateKey = privateKey
    }
    
    func storePrivateKey(key: Data) throws {
    }
    
    func loadPrivateKey() throws -> Data {
        return self.privateKey.web3.hexData!
    }
}
