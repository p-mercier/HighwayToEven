//
//  SmartContract.swift
//  HighwayToEven
//
//  Created by Philippe Mercier on 23/02/2020.
//  Copyright © 2020 Philippe Mercier. All rights reserved.
//

import web3
import BigInt

public class SmartContract {
    
    public func getBalance(completion: @escaping((Error?, BigUInt?) -> Void)) {
        
        guard let client = Session.instance.client else {
            return
        }
        
        let function = SmartContractFunctions.getBalance(contract: Session.instance.contractAddress)
        
        function.call(withClient: client, responseType: SmartContractResponses.bigIntResponse.self) { (error, bigIntResponse) in
            return completion(error, bigIntResponse?.value)
        }
    }
    
    public func playGame(completion: @escaping((Error?, String?) -> Void)) {
        
        guard let client = Session.instance.client, let account = Session.instance.account else {
            return
        }
        
        let function = SmartContractFunctions.playGame(contract: Session.instance.contractAddress, from: EthereumAddress(account.address))
                
        do {
            let tx = try function.transaction()
            
            let from = EthereumAddress(account.address)
            let nonce = 0
            let to = Session.instance.contractAddress
            let value = BigUInt(10_000_000_000_000_000) // 0.01 eth
            let gasPrice = BigUInt(7_000_000_000)
            let gasLimit = BigUInt(100_000)
            
            let transaction = EthereumTransaction(from: from, to: to, value: value, data: tx.data, nonce: nonce, gasPrice: gasPrice, gasLimit: gasLimit, chainId: nil)
            
            client.eth_sendRawTransaction(transaction, withAccount:account) { (error, hash) in
                return completion(error, hash)
            }
        } catch {
            print(error)
        }
    }
    
    public func getEvents(_ h: String?, success: @escaping (ABIEvent?) -> Void, failure: @escaping (Error?) -> Void) {
        
        guard let client = Session.instance.client else {
            return
        }
        
        guard let hash = h else {
            return
        }
        
        let resultSignature = try! SmartContractEvents.Result.signature()
        
        client.getEvents(addresses:[Config.contractAddress], topics: [resultSignature], fromBlock: .Earliest, toBlock: .Latest, eventTypes: [SmartContractEvents.Result.self], completion: { (error, events, unprocessed) in
                        
            for event in events {
                if event.log.transactionHash == hash {
                    return success(event)
                }
            }
            
            return failure(error)
        })
    }
}
