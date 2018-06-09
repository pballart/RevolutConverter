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
import RxSwift

protocol ExchangeServiceProtocol {
    func getExchangeRate(baseCurrency: Currency, onResult: @escaping (_ result: Result<ExchangeDTO, NetworkError> )-> Void)
}

class ExchangeService: ExchangeServiceProtocol {
    let disposeBag = DisposeBag()
    let exchangeProvider: MoyaProvider<ExchangeEndpoint>
    
    init(provider: MoyaProvider<ExchangeEndpoint>) {
        exchangeProvider = provider
    }
    
    func getExchangeRate(baseCurrency: Currency, onResult: @escaping (_ result: Result<ExchangeDTO, NetworkError> )-> Void) {
        let endpoint: ExchangeEndpoint = .exchangeRate(baseCurrency: baseCurrency.code)
        exchangeProvider.rx.request(endpoint).filterSuccessfulStatusCodes().subscribe(onSuccess: { response in
            do {
                _ = try response.filterSuccessfulStatusCodes()
                let decoder = JSONDecoder()
                let exchangeData = try decoder.decode(ExchangeDTO.self, from: response.data)
                onResult(.success(exchangeData))
            }
            catch MoyaError.statusCode {
                onResult(.failure(NetworkError.serverInternalError))
            }
            catch {
                onResult(.failure(NetworkError.responseFormatError))
            }
        }) { error in
            if let err = error as? MoyaError {
                onResult(.failure(NetworkError.translateError(err)))
            } else {
                onResult(.failure(.responseFormatError))
            }
        }.disposed(by: disposeBag)
    }
}
