//
//  CurrencyConverterTests.swift
//  RevolutConverterTests
//
//  Created by Pau Ballart on 08/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import XCTest
import Moya
@testable import RevolutConverter

class CurrencyConverterTests: XCTestCase {
    var exchangeService: ExchangeServiceStub!
    var provider: CurrencyConverterProvider!
    
    override func setUp() {
        super.setUp()
        exchangeService = ExchangeServiceStub()
        provider = CurrencyConverterProvider(apiProvider: exchangeService)
    }
    func testConvertFunction() {
        provider.exchangeRates = ["A": 0.5,
                                  "B": 1.0,
                                  "C": 2.0,
                                  "D": 3.0]
        let amountToConvert: Float = 10.0
        
        var fromCurrency = Currency(code: "B")
        var toCurrency = Currency(code: "C")
        var convertedAmount = CurrencyConverter.convert(amount: amountToConvert,
                                                        fromCurrency: fromCurrency,
                                                        toCurrency: toCurrency,
                                                        provider: provider)
        XCTAssert(convertedAmount == 20.0)
        
        fromCurrency = Currency(code: "B")
        toCurrency = Currency(code: "B")
        convertedAmount = CurrencyConverter.convert(amount: amountToConvert,
                                                    fromCurrency: fromCurrency,
                                                    toCurrency: toCurrency,
                                                    provider: provider)
        XCTAssert(convertedAmount == 10.0)
        
        fromCurrency = Currency(code: "C")
        toCurrency = Currency(code: "A")
        convertedAmount = CurrencyConverter.convert(amount: amountToConvert,
                                                    fromCurrency: fromCurrency,
                                                    toCurrency: toCurrency,
                                                    provider: provider)
        XCTAssert(convertedAmount == 2.5)
        
        fromCurrency = Currency(code: "C")
        toCurrency = Currency(code: "D")
        convertedAmount = CurrencyConverter.convert(amount: amountToConvert,
                                                    fromCurrency: fromCurrency,
                                                    toCurrency: toCurrency,
                                                    provider: provider)
        XCTAssert(convertedAmount == 15)
        
        fromCurrency = Currency(code: "A")
        toCurrency = Currency(code: "D")
        convertedAmount = CurrencyConverter.convert(amount: amountToConvert,
                                                    fromCurrency: fromCurrency,
                                                    toCurrency: toCurrency,
                                                    provider: provider)
        XCTAssert(convertedAmount == 60)
    }
}
