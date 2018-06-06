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
    func didChange(amount: Float)
}


class CurrencyConverterPresenter: NSObject, CurrencyConverterPresenterProtocol {
    fileprivate weak var view: CurrencyConverterViewProtocol!
    fileprivate var provider: CurrencyConverterProviderProtocol!
    
    var tableView: UITableView!
    var dataSource: ConverterDataSource!
    
    init(provider: CurrencyConverterProviderProtocol,
         view: CurrencyConverterViewProtocol) {
        self.provider = provider
        self.view = view
    }
    
    func viewDidLoad(tableView: UITableView) {
        self.tableView = tableView
        dataSource = ConverterDataSource(tableView: tableView, presenter: self)
        self.tableView.delegate = self
        provider.injectDelegate(self)
        provider.startFetchingExchangeRates(baseCurrency: Currency.eurCurrency())
    }
    
    func viewWillDisappear() {
        provider.stopFetchingExchangeRates()
    }
    
    func didChange(amount: Float) {
        guard let data = dataSource.data else { return }
        dataSource.data = provider.updateCurrencies(currencies: data, fromCurrency: data.first!, with: amount)
        updateTableViewCells()
    }
    
    private func updateTableViewCells() {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
            let indexPathsToUpdate = visibleIndexPaths.filter { (indexPath) -> Bool in
                return indexPath != IndexPath(row: 0, section: 0)
            }
            tableView.reloadRows(at: indexPathsToUpdate, with: .automatic)
        }
    }
}

extension CurrencyConverterPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard var exchangeRate = dataSource.data else { return }
        let removedRate = exchangeRate.remove(at: indexPath.row)
        exchangeRate.insert(removedRate, at: 0)
        dataSource.data = exchangeRate
        
        let zeroIndexPath = IndexPath(row: 0, section: 0)
        tableView.performBatchUpdates({
            tableView.moveRow(at: indexPath, to: zeroIndexPath)
            for index in 0..<indexPath.row {
                tableView.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: index+1, section: 0))
            }
        }, completion: nil)
        
        tableView.scrollToRow(at: zeroIndexPath, at: .top, animated: true)
        guard let cell = tableView.cellForRow(at: zeroIndexPath) as? CurrencyConverterTableViewCell else { return }
        cell.rateTextField.becomeFirstResponder()
    }
}

extension CurrencyConverterPresenter: CurrencyConverterProviderDelegate {
    func didReceiveNewExchangeRate(rateDTO: ExchangeDTO) {
        guard let data = dataSource.data else {
            let exchangeRate = ExchangeRate(dto: rateDTO)
            dataSource.data = exchangeRate.rates
            return
        }
        dataSource.data = provider.updateCurrencies(currencies: data, fromCurrency: data.first!, with: data.first!.rate)
        updateTableViewCells()
    }
}
