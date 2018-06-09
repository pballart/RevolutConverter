//
//  CurrencyConverterTableViewDataSource.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 06/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import UIKit

class ConverterDataSource: NSObject, UITableViewDataSource {
    
    var data: [Currency]? {
        didSet {
            if !initialDataLoaded {
                tableView.reloadData()
                initialDataLoaded = true
            }
        }
    }
    
    var initialDataLoaded: Bool = false
    
    weak var tableView: UITableView!
    weak var presenter: CurrencyConverterPresenterProtocol?
    
    init(tableView: UITableView, presenter: CurrencyConverterPresenterProtocol) {
        super.init()
        self.tableView = tableView
        self.tableView.dataSource = self
        self.presenter = presenter
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyConverterTableViewCell.reuseIdentifier) as? CurrencyConverterTableViewCell,
            let currency = data?[indexPath.row] else { return UITableViewCell() }
        cell.currencyCode.text = currency.flag + " " + currency.code
        cell.rateTextField.text = currency.rate == 0 ? "" : String.init(format: "%.2f", currency.rate).replacingOccurrences(of: ".", with: ",")
        cell.delegate = self
        return cell
    }
    
}

extension ConverterDataSource: CurrencyConverterCellDelegate {
    func didUpdate(amount: Float) {
        presenter?.didChange(amount: amount)
    }
    
    func didBeginEditing(cell: CurrencyConverterTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if indexPath.row != 0 {
            presenter?.didSelectRowAt(indexPath: indexPath)
        }
    }
}
