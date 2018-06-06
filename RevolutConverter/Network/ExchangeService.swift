//
//  ExchangeService.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 05/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation
import Moya
import Result

class ExchangeService {
    let exchangeProvider: MoyaProvider<ExchangeEndpoint>
    
    init(provider: MoyaProvider<ExchangeEndpoint>) {
        exchangeProvider = provider
    }
    
    func getExchangeRate(baseCurrency: Currency, onResult: @escaping (_ result: Result<ExchangeDTO, NetworkError> )-> Void) {
        exchangeProvider.request(.exchangeRate(baseCurrency: baseCurrency.code)) { (result) in
            switch result {
            case let .success(moyaResponse):
                do {
                    _ = try moyaResponse.filterSuccessfulStatusCodes()
                    let decoder = JSONDecoder()
                    let exchangeData = try decoder.decode(ExchangeDTO.self, from: moyaResponse.data)
                    onResult(.success(exchangeData))
                }
                catch MoyaError.statusCode {
                    onResult(.failure(NetworkError.serverInternalError))
                }
                catch {
                    onResult(.failure(NetworkError.responseFormatError))
                }
            case let .failure(error):
                onResult(.failure(NetworkError.translateError(error)))
            }
        }
    }
}
