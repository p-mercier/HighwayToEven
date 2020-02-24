//
//  SmartContractFunctions.swift
//  HighwayToEven
//
//  Created by Philippe Mercier on 23/02/2020.
//  Copyright © 2020 Philippe Mercier. All rights reserved.
//

import web3
import BigInt

public enum SmartContractFunctions {
    
    public struct getBalance: ABIFunction {
        public static let name = "getBalance"
        public let gasPrice: BigUInt? = nil
        public let gasLimit: BigUInt? = nil
        public var contract: EthereumAddress
        public let from: EthereumAddress?
        
        public init(contract: EthereumAddress, from: EthereumAddress? = nil) {
            self.contract = contract
            self.from = from
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
        }
    }
    
    public struct playGame: ABIFunction {
        public static let name = "playGame"
        public let gasPrice: BigUInt? = BigUInt(1_000_000_000) // 1 gwei in wei
        public let gasLimit: BigUInt? = BigUInt(500_000)
        public var contract: EthereumAddress
        public let from: EthereumAddress?
        
        public init(contract: EthereumAddress, from: EthereumAddress? = nil) {
            self.contract = contract
            self.from = from
        }
        
        public func encode(to encoder: ABIFunctionEncoder) throws {
        }
    }
}
