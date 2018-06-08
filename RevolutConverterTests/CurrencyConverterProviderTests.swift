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
    
    
}
