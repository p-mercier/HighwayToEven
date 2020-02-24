//
//  SmartContractEvents.swift
//  HighwayToEven
//
//  Created by Philippe Mercier on 23/02/2020.
//  Copyright © 2020 Philippe Mercier. All rights reserved.
//

import web3
import BigInt

public enum SmartContractEvents {
    
    public struct Result: ABIEvent {
        public static let name = "Result"
        public static let types: [ABIType.Type] = [ EthereumAddress.self , BigUInt.self, String.self]
        public static let typesIndexed = [false, false, false]
        public let log: EthereumLog
        
        public let user: EthereumAddress
        public let numberGenerated: BigUInt
        public let outcome: String
        
        public init?(topics: [ABIType], data: [ABIType], log: EthereumLog) throws {
            try Result.checkParameters(topics, data)
            self.log = log
            self.user = try data[0].decoded()
            self.numberGenerated = try data[1].decoded()
            self.outcome = try data[2].decoded()
        }
    }
}
