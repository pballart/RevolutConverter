//
//  CurrencyConverterView.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 05/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import UIKit

class CurrencyConverterView: UIViewController, CurrencyConverterViewProtocol {
    fileprivate var presenter: CurrencyConverterPresenterProtocol!
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = CurrencyConverterPresenter(provider: CurrencyConverterProvider(), view: self)
        presenter.viewDidLoad()
    }
    
}

