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
    
    var tableView: UITableView!
    var dataSource: ConverterDataSource!
    
    init(provider: CurrencyConverterProviderProtocol,
         view: CurrencyConverterViewProtocol) {
        self.provider = provider
        self.view = view
    }
    
    func viewDidLoad(tableView: UITableView) {
        self.tableView = tableView
        dataSource = ConverterDataSource(tableView: tableView)
        self.tableView.delegate = self
        provider.injectDelegate(self)
        provider.startFetchingExchangeRates(baseCurrency: Currency.eurCurrency())
    }
    
    func viewWillDisappear() {
        provider.stopFetchingExchangeRates()
    }
    
}

extension CurrencyConverterPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard var exchangeRate = dataSource.data else { return }
        exchangeRate.rates.swapAt(indexPath.row, 0)
        dataSource.data = exchangeRate
        let zeroIndexPath = IndexPath(row: 0, section: 0)
        tableView.performBatchUpdates({
            tableView.moveRow(at: indexPath, to: zeroIndexPath)
            tableView.moveRow(at: zeroIndexPath, to: indexPath)
        }, completion: nil)
        
        tableView.scrollToRow(at: zeroIndexPath, at: .top, animated: true)
        guard let cell = tableView.cellForRow(at: zeroIndexPath) as? CurrencyConverterTableViewCell else { return }
        cell.rateTextField.becomeFirstResponder()
    }
}

extension CurrencyConverterPresenter: CurrencyConverterProviderDelegate {
    func didReceiveNewExchangeRate(rateDTO: ExchangeDTO) {
        guard var data = dataSource.data else {
            let exchangeRate = ExchangeRate(dto: rateDTO)
            dataSource.data = exchangeRate
            return
        }
        for (index, rate) in data.rates.enumerated() where rate.code != "EUR" {
            guard let newRate = rateDTO.rates[rate.code] else { return }
            let updatedCurrency = Currency(code: rate.code, rate: newRate)
            data.rates[index] = updatedCurrency
        }
        dataSource.data = data
        
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
            let indexPathsToUpdate = visibleIndexPaths.filter { (indexPath) -> Bool in
                return indexPath != IndexPath(row: 0, section: 0)
            }
            tableView.reloadRows(at: indexPathsToUpdate, with: .automatic)
        }
    }
}
