//
//  Currency.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 06/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation

struct Currency: Equatable {
    let code: String
    let rate: Float?
    
    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.code == rhs.code
    }
    
    static func eurCurrency() -> Currency {
        return Currency(code: "EUR")
    }
    
    init(code: String) {
        self.code = code
        self.rate = nil
    }
    
    init(code: String, rate: Float) {
        self.code = code
        self.rate = rate
    }
}
