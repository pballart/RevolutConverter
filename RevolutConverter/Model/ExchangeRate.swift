//
//  ExchangeRate.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 06/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation

struct ExchangeRate {
    let base: String
    let rates: [Currency]
    
    init(dto: ExchangeDTO) {
        self.base = dto.base
        self.rates = dto.rates.map({ (key, value) -> Currency in
            return Currency(code: key, rate: value)
        })
    }
}

