//
//  CurrencyConverterPresenterTests.swift
//  RevolutConverterTests
//
//  Created by Pau Ballart on 09/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import XCTest
import Moya
@testable import RevolutConverter

class CurrencyConverterPresenterTests: XCTestCase {
    var view: CurrencyConverterViewMock!
    var provider: CurrencyConverterProviderStub!
    var presenter: CurrencyConverterPresenter!
    
    override func setUp() {
        super.setUp()
        
        view = CurrencyConverterViewMock()
        provider = CurrencyConverterProviderStub()
        presenter = CurrencyConverterPresenter(provider: provider, view: view)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewDidLoad() {
        presenter.viewDidLoad()
        
        XCTAssert(provider.result.contains("injectDelegate"))
        XCTAssert(provider.result.contains("startFetchingExchangeRates"))
    }
    
    func testViewWillDisappear() {
        presenter.viewWillDisappear()
        XCTAssert(provider.result.contains("stopFetchingExchangeRates"))
    }
    
    func testDidChangeAmount() {
        let amount: Float = 1.0
        view.setViewModel([])
        
        presenter.didChange(amount: amount)
        XCTAssert(provider.result == "")
        
        view.setViewModel([Currency(code: "A")])
        presenter.didChange(amount: amount)
        XCTAssert(view.result.contains("setViewModel"))
        XCTAssert(view.result.contains("updateTableViewCells"))
    }
    
    func testDidSelectRowAtIndexPath() {
        let indexPath = IndexPath(row: 0, section: 0)
        
        view.setViewModel([])
        presenter.didSelectRowAt(indexPath: indexPath)
        XCTAssert(view.getViewModel().count == 0)
        
        view.setViewModel([Currency(code: "A"), Currency(code: "B"), Currency(code: "C")])
        presenter.didSelectRowAt(indexPath: indexPath)
        XCTAssert(view.result.contains("setViewModel"))
        XCTAssert(view.result.contains("moveTableViewCellsFor"))
    }

    func testDidReceiveNewExchangeRate() {
        let dto = ExchangeDTO(base: "EUR", rates: ["A": 1.0])
        view.setViewModel([])
        presenter.didReceiveNewExchangeRate(rateDTO: dto)
        XCTAssert(view.result.contains("setViewModel"))
        XCTAssert(view.getViewModel().count > 0)
        
        view.setViewModel([Currency(code: "P")])
        presenter.didReceiveNewExchangeRate(rateDTO: dto)
        XCTAssert(view.result.contains("setViewModel"))
        XCTAssert(view.result.contains("updateTableViewCells"))
    }
}
