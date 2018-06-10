//
//  CurrencyConverterPresenter.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 06/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation

protocol CurrencyConverterViewProtocol: class {
    func setViewModel(_ viewModel: [Currency])
    func getViewModel() -> [Currency]
    func updateTableViewCells()
    func moveTableViewCellsFor(indexPath: IndexPath)
}

protocol CurrencyConverterPresenterProtocol: class {
    func viewDidLoad()
    func viewWillDisappear()
    func didChange(amount: Float)
    func didSelectRowAt(indexPath: IndexPath)
}

class CurrencyConverterPresenter: CurrencyConverterPresenterProtocol {
    fileprivate weak var view: CurrencyConverterViewProtocol!
    fileprivate var provider: CurrencyConverterProviderProtocol
    
    init(provider: CurrencyConverterProviderProtocol,
         view: CurrencyConverterViewProtocol) {
        self.provider = provider
        self.view = view
    }
    
    func viewDidLoad() {
        provider.injectDelegate(self)
        provider.startFetchingExchangeRates(baseCurrency: Currency.eurCurrency())
    }
    
    func viewWillDisappear() {
        provider.stopFetchingExchangeRates()
    }
    
    func didChange(amount: Float) {
        updateCurrenciesWith(amount: amount)
    }
    
    private func updateCurrenciesWith(amount: Float) {
        let data = view.getViewModel()
        guard data.count > 0 else { return }
        view.setViewModel(provider.updateCurrencies(currencies: data, fromCurrency: data.first!, with: amount))
        view.updateTableViewCells()
    }
    
    func didSelectRowAt(indexPath: IndexPath) {
        var exchangeRate = view.getViewModel()
        guard exchangeRate.count > 0 else { return }
        let removedRate = exchangeRate.remove(at: indexPath.row)
        exchangeRate.insert(removedRate, at: 0)
        view.setViewModel(exchangeRate)
        view.moveTableViewCellsFor(indexPath: indexPath)
    }
}

extension CurrencyConverterPresenter: CurrencyConverterProviderDelegate {
    func didReceiveNewExchangeRate(rateDTO: ExchangeDTO) {
        let data = view.getViewModel()
        guard data.count > 0 else {
            let exchangeRate = ExchangeRate(dto: rateDTO)
            let sortedRates = exchangeRate.rates.sorted(by: { (c1, c2) -> Bool in
                return c1.code < c2.code
            })
            view.setViewModel(sortedRates)
            return
        }
        updateCurrenciesWith(amount: data.first!.rate)
    }
}
