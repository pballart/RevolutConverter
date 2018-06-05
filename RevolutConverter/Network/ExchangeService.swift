//
//  ExchangeService.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 05/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation
import Moya
import RxSwift

class ExchangeService {
    let disposeBag = DisposeBag()
    let exchangeProvider: MoyaProvider<ExchangeEndpoint>.CompatibleType
    
    init() {
        exchangeProvider = MoyaProvider<ExchangeEndpoint>()
    }
}
