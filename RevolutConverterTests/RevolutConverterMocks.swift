//
//  RevolutConverterMocks.swift
//  RevolutConverterTests
//
//  Created by Pau Ballart on 10/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import UIKit
@testable import RevolutConverter

class CurrencyConverterViewMock: UIViewController, CurrencyConverterViewProtocol {
    
    var model = [Currency]()
    var result = ""
    
    func setViewModel(_ viewModel: [Currency]) {
        result += "setViewModel"
        model = viewModel
    }
    
    func getViewModel() -> [Currency] {
        result += "getViewModel"
        return model
    }
    
    func updateTableViewCells() {
        result += "updateTableViewCells"
    }
    
    func moveTableViewCellsFor(indexPath: IndexPath) {
        result += "moveTableViewCellsFor"
    }
    
}
