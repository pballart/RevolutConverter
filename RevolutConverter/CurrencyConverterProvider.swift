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
    func didReceiveNewExchangeRate(rate: ExchangeRate)
}

class CurrencyConverterProvider: CurrencyConverterProviderProtocol {
    weak var delegate: CurrencyConverterProviderDelegate?
    
    let apiProvider: ExchangeServiceProtocol = ExchangeService(provider: MoyaProvider<ExchangeEndpoint>())
    
    func injectDelegate(_ delegate: CurrencyConverterProviderDelegate) {
        self.delegate = delegate
    }
    
    var timer: Timer?
    var baseCurrency: Currency?
    
    func startFetchingExchangeRates(baseCurrency: Currency) {
        print("start fetching")
        self.baseCurrency = baseCurrency
        fetchExchangeRate()
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fetchExchangeRate), userInfo: nil, repeats: true)
    }
    
    func stopFetchingExchangeRates() {
        print("stop fetching")
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func fetchExchangeRate() {
        print("timer fired")
        guard let currency = baseCurrency else { return }
        apiProvider.getExchangeRate(baseCurrency: currency) { (result) in
            switch result {
            case .success(let exchangeRateDto):
                let exchangeRate = ExchangeRate(dto: exchangeRateDto)
                self.delegate?.didReceiveNewExchangeRate(rate: exchangeRate)
                break
            case .failure(let error):
                print("Error getting exchange rate: \(error)")
            }
        }
    }
    
}
