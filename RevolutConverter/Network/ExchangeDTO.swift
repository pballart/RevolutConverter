//
//  ExchangeDTO.swift
//  RevolutConverter
//
//  Created by Pau Ballart on 06/06/2018.
//  Copyright © 2018 Pau Ballart. All rights reserved.
//

import Foundation

struct ExchangeDTO: Codable {
    let base: String
    let rates: [String: Float]
}
