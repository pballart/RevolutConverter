//
//  CurrencyExchangeService.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 05/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation
import Moya
import RxSwift

enum ExchangeEndpoint {
    case exchangeRate(baseCurrency: String)
}

extension ExchangeEndpoint: TargetType {
    var baseURL: URL {
        return URL(string: "https://revolut.duckdns.org")!
    }
    
    var path: String {
        switch self {
        case .exchangeRate:
            return "/latest"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .exchangeRate:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .exchangeRate(let baseCurrency):
            return ["base": baseCurrency]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .exchangeRate:
            return URLEncoding.default
        }
    }
    
    var sampleData: Data {
        switch self {
        case .exchangeRate:
            return Data()
        }
    }
    
    var task: Task {
        switch self {
        case .exchangeRate:
            return .requestParameters(parameters: parameters ?? [:], encoding: parameterEncoding)
        }
    }
    
    var headers: [String : String]? {
        return [:]
    }
    
    
}
