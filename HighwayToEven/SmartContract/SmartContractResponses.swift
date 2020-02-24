//
//  SmartContractResponses.swift
//  HighwayToEven
//
//  Created by Philippe Mercier on 23/02/2020.
//  Copyright © 2020 Philippe Mercier. All rights reserved.
//

import web3
import BigInt

public enum SmartContractResponses {
    
    public struct bigIntResponse: ABIResponse {
        public static var types: [ABIType.Type] = [ BigUInt.self ]
        public let value: BigUInt
        
        public init?(values: [ABIType]) throws {
            self.value = try values[0].decoded()
        }
    }
}
