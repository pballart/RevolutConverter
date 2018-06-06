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
    func viewDidLoad()
}


class CurrencyConverterPresenter: CurrencyConverterPresenterProtocol {
    fileprivate weak var view: CurrencyConverterViewProtocol!
    fileprivate var provider: CurrencyConverterProviderProtocol!
    var tableView : UITableView? = nil
    
    init(provider: CurrencyConverterProviderProtocol,
         view: CurrencyConverterViewProtocol) {
        self.provider = provider
        self.view = view
    }
    
    func viewDidLoad() {
        print("View did load")
        provider.startFetchingExchangeRates(baseCurrency: Currency.eurCurrency())
    }
    
    
}
