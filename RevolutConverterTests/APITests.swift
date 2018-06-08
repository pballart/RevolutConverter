//
//  APITests.swift
//  RevolutConverterTests
//
//  Created by Pau Ballart on 05/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import XCTest
import Moya
@testable import RevolutConverter

class APITests: XCTestCase {
    
    func testAPICallSucceeds() {
        let eurCurrency = Currency.eurCurrency()
        let stubbingProvider = MoyaProvider<ExchangeEndpoint>(stubClosure: MoyaProvider.immediatelyStub)
        let service = ExchangeService.init(provider: stubbingProvider)
        
        let expect = expectation(description: "API Call")
        service.getExchangeRate(baseCurrency: eurCurrency) { result in
            switch result {
            case .success(let exchangeInfo):
                XCTAssert(exchangeInfo.base == eurCurrency.code)
                XCTAssertFalse(exchangeInfo.rates.isEmpty)
            case .failure:
                XCTFail()
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                XCTFail("Expectation timeout: \(error)")
            }
        }
    }
    
    func testAPICallFails() {
        let eurCurrency = Currency.eurCurrency()

        let endpointClosure = { (target: ExchangeEndpoint) -> Endpoint in
            return Endpoint(url: target.baseURL.absoluteString, sampleResponseClosure: {.networkResponse(500, target.sampleData)}, method: target.method, task: target.task, httpHeaderFields: target.headers)
        }
        
        let stubbingProvider = MoyaProvider<ExchangeEndpoint>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)
        let service = ExchangeService.init(provider: stubbingProvider)
        
        let expect = expectation(description: "API Call")
        service.getExchangeRate(baseCurrency: eurCurrency) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let networkError):
                XCTAssert(networkError == .serverInternalError)
            }
            expect.fulfill()
        }
        waitForExpectations(timeout: 5) { (error) in
            if let error = error {
                XCTFail("Expectation timeout: \(error)")
            }
        }
    }

    
}
