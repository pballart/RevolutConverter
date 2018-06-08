//
//  RevolutConverterStubs.swift
//  RevolutConverterTests
//
//  Created by Pau Ballart on 08/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import XCTest
import Moya
@testable import RevolutConverter

class CurrencyConverterViewStub: UIViewController, CurrencyConverterViewProtocol {

}

class CurrencyConverterPresenterStub: CurrencyConverterPresenterProtocol {
    
    var result = ""
    
    func viewDidLoad(tableView: UITableView) {
        result = "viewDidLoad"
    }
    
    func viewWillDisappear() {
        result = "viewWillDisappear"
    }
    
    func didChange(amount: Float) {
        result = "didChangeAmount"
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        result = "didSelectRowAtIndexPath"
    }
}

class CurrencyConverterProviderStub: CurrencyConverterProviderProtocol {
    
    var result = ""

    func injectDelegate(_ delegate: CurrencyConverterProviderDelegate) {
        result = "injectDelegate"
    }
    
    func startFetchingExchangeRates(baseCurrency: Currency) {
        result = "startFetchingExchangeRates"
    }
    
    func stopFetchingExchangeRates() {
        result = "stopFetchingExchangeRates"
    }
    
    func rateForCurrency(_ currency: Currency) -> Float {
        result = "rateForCurrency"
        return 1.0
    }
    
    func updateCurrencies(currencies: [Currency], fromCurrency: Currency, with amount: Float) -> [Currency] {
        result = "updateCurrencies"
        return []
    }
}
