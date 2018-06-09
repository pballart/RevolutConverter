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
    var view: CurrencyConverterViewStub!
    var provider: CurrencyConverterProviderStub!
    var presenter: CurrencyConverterPresenter!
    
    
    override func setUp() {
        super.setUp()
        
        view = CurrencyConverterViewStub()
        provider = CurrencyConverterProviderStub()
        presenter = CurrencyConverterPresenter(provider: provider, view: view)
        
        let tableView = UITableView()
        presenter.tableView = tableView
        presenter.dataSource = ConverterDataSource(tableView: tableView, presenter: presenter)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testViewDidLoad() {
        let tableView = UITableView()
        presenter.viewDidLoad(tableView: tableView)
        
        XCTAssert(presenter.tableView == tableView)
        XCTAssertNotNil(presenter.dataSource)
        XCTAssert(provider.result.contains("injectDelegate"))
        XCTAssert(provider.result.contains("startFetchingExchangeRates"))
    }
    
    func testViewWillDisappear() {
        presenter.viewWillDisappear()
        XCTAssert(provider.result.contains("stopFetchingExchangeRates"))
    }
    
    func testDidChangeAmount() {
        let amount: Float = 1.0
        presenter.dataSource.data = []
        
        presenter.didChange(amount: amount)
        XCTAssert(provider.result == "")
        
        presenter.dataSource.data = [Currency(code: "A")]
        presenter.didChange(amount: amount)
        XCTAssert(provider.result.contains("updateCurrencies"))
    }
    
    func testDidSelectRowAtIndexPath() {
        let indexPath = IndexPath(row: 0, section: 0)
        presenter.dataSource.data = []
        presenter.didSelectRowAt(indexPath: indexPath)
        XCTAssert(presenter.dataSource.data!.count == 0)
        
        presenter.dataSource.data = [Currency(code: "A"), Currency(code: "B"), Currency(code: "C")]
        presenter.tableView.reloadData()
        presenter.didSelectRowAt(indexPath: indexPath)
        XCTAssert(presenter.dataSource.data!.count == 3)
    }

    func testDidReceiveNewExchangeRate() {
        let dto = ExchangeDTO(base: "EUR", rates: ["A": 1.0])
        presenter.dataSource.data = nil
        presenter.didReceiveNewExchangeRate(rateDTO: dto)
        XCTAssertNotNil(presenter.dataSource.data)
        XCTAssert(presenter.dataSource.data!.count > 0)
        
        presenter.dataSource.data = [Currency(code: "P")]
        presenter.didReceiveNewExchangeRate(rateDTO: dto)
        XCTAssert(provider.result.contains("updateCurrencies"))
    }
}
