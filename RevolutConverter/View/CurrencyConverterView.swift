//
//  CurrencyConverterView.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 05/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import UIKit
import Moya

class CurrencyConverterView: UIViewController, CurrencyConverterViewProtocol {
    
    fileprivate var presenter: CurrencyConverterPresenterProtocol?
    fileprivate var dataSource: ConverterDataSource!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let exchangeService = ExchangeService(provider: MoyaProvider<ExchangeEndpoint>())
        let provider = CurrencyConverterProvider(apiProvider: exchangeService)
        presenter = CurrencyConverterPresenter(provider: provider, view: self)
        dataSource = ConverterDataSource(tableView: tableView, presenter: presenter!)
        self.tableView.delegate = self
        self.tableView.keyboardDismissMode = .onDrag
        presenter?.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter?.viewWillDisappear()
    }
    
    func setViewModel(_ viewModel: [Currency]) {
        dataSource.data = viewModel
    }
    
    func getViewModel() -> [Currency] {
        return dataSource.data ?? []
    }
    
    func updateTableViewCells() {
        if let visibleIndexPaths = tableView.indexPathsForVisibleRows {
            let indexPathsToUpdate = visibleIndexPaths.filter { (indexPath) -> Bool in
                return indexPath != IndexPath(row: 0, section: 0)
            }
            tableView.reloadRows(at: indexPathsToUpdate, with: .none)
        }
    }
    
    func moveTableViewCellsFor(indexPath: IndexPath) {
        let zeroIndexPath = IndexPath(row: 0, section: 0)
        tableView.performBatchUpdates({
            tableView.moveRow(at: indexPath, to: zeroIndexPath)
            for index in 0..<indexPath.row {
                tableView.moveRow(at: IndexPath(row: index, section: 0), to: IndexPath(row: index+1, section: 0))
            }
        }, completion: { (finished) in
            if finished {
                self.tableView.scrollToRow(at: zeroIndexPath, at: .top, animated: false)
            }
        })
    }
}

extension CurrencyConverterView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CurrencyConverterTableViewCell else { return }
        cell.rateTextField.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
