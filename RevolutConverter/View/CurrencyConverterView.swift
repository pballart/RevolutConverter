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
    fileprivate var presenter: CurrencyConverterPresenterProtocol!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let exchangeService = ExchangeService(provider: MoyaProvider<ExchangeEndpoint>())
        let provider = CurrencyConverterProvider(apiProvider: exchangeService)
        presenter = CurrencyConverterPresenter(provider: provider, view: self)
        presenter.viewDidLoad(tableView: tableView)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        presenter.viewWillDisappear()
    }
}

