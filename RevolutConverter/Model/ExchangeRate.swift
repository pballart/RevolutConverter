//
//  ExchangeRate.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 06/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation

struct ExchangeRate {
    var base: String
    var rates: [Currency]
    
    init(dto: ExchangeDTO) {
        self.base = dto.base
        var serverRates = dto.rates.map({ (key, value) -> Currency in
            return Currency(code: key, rate: value)
        })
        serverRates.append(Currency(code: dto.base, rate: 1))
        self.rates = serverRates
    }
}
