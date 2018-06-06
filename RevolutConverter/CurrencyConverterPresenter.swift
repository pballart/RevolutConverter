//
//  CurrencyConverterPresenter.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 06/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import UIKit

protocol CurrencyConverterViewProtocol: class {
    
}

protocol CurrencyConverterPresenterProtocol: class {
    func viewDidLoad(tableView: UITableView)
    func viewWillDisappear()
}


class CurrencyConverterPresenter: NSObject, CurrencyConverterPresenterProtocol {
    fileprivate weak var view: CurrencyConverterViewProtocol!
    fileprivate var provider: CurrencyConverterProviderProtocol!
    
    var tableView: UITableView?
    var dataSource: ConverterDataSource!
    
    var exchangeRate: ExchangeRate? {
        didSet {
            print("exchange rate updated")
            transformNewRateForDataSource()
        }
    }
    
    init(provider: CurrencyConverterProviderProtocol,
         view: CurrencyConverterViewProtocol) {
        self.provider = provider
        self.view = view
    }
    
    func viewDidLoad(tableView: UITableView) {
        self.tableView = tableView
        dataSource = ConverterDataSource(tableView: tableView)
        self.tableView?.delegate = self
        provider.injectDelegate(self)
        provider.startFetchingExchangeRates(baseCurrency: Currency.eurCurrency())
    }
    
    func viewWillDisappear() {
        provider.stopFetchingExchangeRates()
    }
    
    private func transformNewRateForDataSource() {
        if dataSource.data == nil {
            dataSource.data = exchangeRate
        } else {
            
        }
    }
}

extension CurrencyConverterPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedCurrency = exchangeRate?.rates.remove(at: indexPath.row) else { return }
        exchangeRate?.rates.insert(selectedCurrency, at: 0)
        dataSource.data = exchangeRate
        tableView.beginUpdates()
        let zeroIndexPath = IndexPath(row: 0, section: 0)
        tableView.moveRow(at: indexPath, to: zeroIndexPath)
        tableView.moveRow(at: zeroIndexPath, to: indexPath)
        tableView.endUpdates()
        tableView.scrollToRow(at: zeroIndexPath, at: .top, animated: true)
        guard let cell = tableView.cellForRow(at: zeroIndexPath) as? CurrencyConverterTableViewCell else { return }
        cell.rateTextField.becomeFirstResponder()
    }
}

extension CurrencyConverterPresenter: CurrencyConverterProviderDelegate {
    func didReceiveNewExchangeRate(rate: ExchangeRate) {
        self.exchangeRate = rate
    }
}
