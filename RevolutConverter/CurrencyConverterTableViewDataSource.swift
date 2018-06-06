//
//  CurrencyConverterTableViewDataSource.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 06/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import UIKit

class ConverterDataSource: NSObject, UITableViewDataSource {
    
    var data: ExchangeRate? {
        didSet {
            if !initialDataLoaded {
                tableView.reloadData()
                initialDataLoaded = true
            }
        }
    }
    
    var initialDataLoaded: Bool = false
    
    weak var tableView: UITableView!
    
    init(tableView: UITableView) {
        super.init()
        self.tableView = tableView
        self.tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data?.rates.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyConverterTableViewCell.reuseIdentifier) as? CurrencyConverterTableViewCell,
            let currency = data?.rates[indexPath.row] else { return UITableViewCell() }
        cell.currencyCode.text = currency.code
        cell.rateTextField.text = String.init(format: "%.4f", currency.rate)
        return cell
    }
    
}
