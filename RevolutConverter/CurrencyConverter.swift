//
//  CurrencyConverter.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 06/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation

class CurrencyConverter {
    static func convert(amount: Float,
                        fromCurrency: Currency,
                        toCurrency: Currency,
                        provider: CurrencyConverterProviderProtocol) -> Float {
        if fromCurrency == toCurrency { return amount }
        let fromRate = provider.rateForCurrency(fromCurrency)
        let toRate = provider.rateForCurrency(toCurrency)
        return amount * toRate / fromRate
    }
}
