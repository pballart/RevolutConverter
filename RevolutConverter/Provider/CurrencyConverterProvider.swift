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
    func rateForCurrency(_ currency: Currency) -> Float
    func updateCurrencies(currencies: [Currency], fromCurrency: Currency, with amount: Float) -> [Currency]
}

protocol CurrencyConverterProviderDelegate: class {
    func didReceiveNewExchangeRate(rateDTO: ExchangeDTO)
}

class CurrencyConverterProvider: CurrencyConverterProviderProtocol {
    weak var delegate: CurrencyConverterProviderDelegate?
    
    let apiProvider: ExchangeServiceProtocol
    
    init (apiProvider: ExchangeServiceProtocol) {
        self.apiProvider = apiProvider
    }
    func injectDelegate(_ delegate: CurrencyConverterProviderDelegate) {
        self.delegate = delegate
    }
    
    var timer: Timer?
    var baseCurrency: Currency?
    var exchangeRates: [String: Float]?
    
    func startFetchingExchangeRates(baseCurrency: Currency) {
        self.baseCurrency = baseCurrency
        fetchExchangeRate()
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(fetchExchangeRate),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    func stopFetchingExchangeRates() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func fetchExchangeRate() {
        guard let currency = baseCurrency else { return }
        apiProvider.getExchangeRate(baseCurrency: currency) { (result) in
            switch result {
            case .success(let exchangeRateDTO):
                self.exchangeRates = exchangeRateDTO.rates
                self.delegate?.didReceiveNewExchangeRate(rateDTO: exchangeRateDTO)
            case .failure(let error):
                print("Error getting exchange rate: \(error)")
            }
        }
    }
    
    func rateForCurrency(_ currency: Currency) -> Float {
        if currency.code == "EUR" { return 1 }
        guard let rate = exchangeRates?[currency.code] else { return 1 }
        return rate
    }
    
    func updateCurrencies(currencies: [Currency], fromCurrency: Currency, with amount: Float) -> [Currency] {
        var updatedCurrencies = [Currency]()
        for currencyToUpdate in currencies {
            let newAmount = CurrencyConverter.convert(amount: amount,
                                                      fromCurrency: fromCurrency,
                                                      toCurrency: currencyToUpdate,
                                                      provider: self)
            updatedCurrencies.append(Currency(code: currencyToUpdate.code, rate: newAmount))
        }
        return updatedCurrencies
    }
    
}
