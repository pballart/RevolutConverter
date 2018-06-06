//
//  CurrencyExchangeService.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 05/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation
import Moya

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
            let sampleRespone = """
                                {
                                    "base": "EUR",
                                    "date": "2018-06-05",
                                    "rates": {
                                        "AUD": 1.5314,
                                        "BGN": 1.9531,
                                        "BRL": 4.3865,
                                        "CAD": 1.5137,
                                        "CHF": 1.1499,
                                        "CNY": 7.4666,
                                        "CZK": 25.617,
                                        "DKK": 7.4322,
                                        "GBP": 0.87269,
                                        "HKD": 9.1484,
                                        "HRK": 7.3728,
                                        "HUF": 318.24,
                                        "IDR": 16186.0,
                                        "ILS": 4.1685,
                                        "INR": 78.289,
                                        "ISK": 123.33,
                                        "JPY": 127.9,
                                        "KRW": 1248.6,
                                        "MXN": 23.764,
                                        "MYR": 4.6459,
                                        "NOK": 9.4876,
                                        "NZD": 1.6613,
                                        "PHP": 61.138,
                                        "PLN": 4.2827,
                                        "RON": 4.6461,
                                        "RUB": 72.715,
                                        "SEK": 10.236,
                                        "SGD": 1.5571,
                                        "THB": 37.285,
                                        "TRY": 5.3782,
                                        "USD": 1.1659,
                                        "ZAR": 14.802
                                    }
                                }
                                """
            return sampleRespone.utf8Encoded
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

private extension String {
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
