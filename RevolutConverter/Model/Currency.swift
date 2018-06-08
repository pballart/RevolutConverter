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
    let flag: String
    let rate: Float
    
    public static func == (lhs: Currency, rhs: Currency) -> Bool {
        return lhs.code == rhs.code
    }
    
    static func eurCurrency() -> Currency {
        return Currency(code: "EUR")
    }
    
    init(code: String, rate: Float = 1) {
        self.code = code
        self.rate = rate
        let currencyCountries = IsoCountryCodes.searchByCurrency(currency: code).filter { (info) -> Bool in
            return code.contains(info.alpha2)
        }
        var candidateFlag = currencyCountries.first?.flag
        if code == "EUR" {
            candidateFlag = IsoCountries.flag(countryCode: "EU")
        } 
        self.flag = candidateFlag ?? ""
    }
}
