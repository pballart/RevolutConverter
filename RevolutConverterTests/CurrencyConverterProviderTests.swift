//
//  CurrencyConverterProviderTests.swift
//  RevolutConverterTests
//
//  Created by Pau Ballart on 08/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import XCTest
import Moya
@testable import RevolutConverter

class CurrencyConverterProviderTests: XCTestCase {
    var view: CurrencyConverterViewStub!
    var presenter: CurrencyConverterPresenterStub!
    var exchangeService: ExchangeServiceStub!
    var provider: CurrencyConverterProvider!
    
    let baseCurrency = Currency.eurCurrency()
    
    override func setUp() {
        super.setUp()
        
        view = CurrencyConverterViewStub()
        presenter = CurrencyConverterPresenterStub()
        exchangeService = ExchangeServiceStub()
        provider = CurrencyConverterProvider(apiProvider: exchangeService)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testStartFetchingExchangeRates() {
        provider.startFetchingExchangeRates(baseCurrency: baseCurrency)
        
        XCTAssertNotNil(provider.baseCurrency)
        XCTAssertNotNil(provider.timer)
        XCTAssert(exchangeService.result.contains("getExchangeRate"))
    }
    
    func testStopFetchingExchangeRates() {
        provider.stopFetchingExchangeRates()
        XCTAssertNil(provider.timer)
    }
    
    func testRateForCurrency() {
        provider.exchangeRates = ["A": 0.5,
                                  "B": 1.0,
                                  "C": 2.0,
                                  "D": 3.0]
        
        var rate = provider.rateForCurrency(Currency(code: "A"))
        XCTAssert(rate == 0.5)
        rate = provider.rateForCurrency(Currency(code: "B"))
        XCTAssert(rate == 1.0)
        rate = provider.rateForCurrency(Currency(code: "C"))
        XCTAssert(rate == 2.0)
        rate = provider.rateForCurrency(Currency(code: "D"))
        XCTAssert(rate == 3.0)
        rate = provider.rateForCurrency(Currency(code: "EUR"))
        XCTAssert(rate == 1)
        rate = provider.rateForCurrency(Currency(code: "NOT_FOUND"))
        XCTAssert(rate == 1)
    }
    
    func testUpdateCurrencies() {
        let c1 = Currency(code: "A")
        let c2 = Currency(code: "B")
        let input = [c1, c2]
        let output = provider.updateCurrencies(currencies: input, fromCurrency: Currency.eurCurrency(), with: 1.0)
        XCTAssert(output.count == input.count)
    }
}
