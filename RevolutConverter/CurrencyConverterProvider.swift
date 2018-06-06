//
//  CurrencyConverterProvider.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 06/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation
import Moya

protocol CurrencyConverterProviderProtocol: class {
    func injectDelegate(_ delegate: CurrencyConverterProviderDelegate)
    func startFetchingExchangeRates(baseCurrency: Currency)
    func stopFetchingExchangeRates()
}

protocol CurrencyConverterProviderDelegate: class {
    func didReceiveNewExchangeRate()
}

class CurrencyConverterProvider: CurrencyConverterProviderProtocol {
    weak var delegate: CurrencyConverterProviderDelegate?
    
    let apiProvider: ExchangeServiceProtocol = ExchangeService(provider: MoyaProvider<ExchangeEndpoint>())
    
    func injectDelegate(_ delegate: CurrencyConverterProviderDelegate) {
        self.delegate = delegate
    }
    
    var timer: Timer?
    
    func startFetchingExchangeRates(baseCurrency: Currency) {
        print("start fetching")
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fetchExchangeRate), userInfo: nil, repeats: true)
    }
    
    func stopFetchingExchangeRates() {
        print("stop fetching")
        timer = nil
    }
    
    @objc private func fetchExchangeRate() {
        print("timer fired")
    }
    
}
