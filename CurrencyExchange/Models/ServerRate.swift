//
//  ServerRate.swift
//  CurrencyExchange
//
//  Created by Namik Yaqubov on 19/04/2019.
//  Copyright © 2019 Namik Yaqubov. All rights reserved.
//

struct ServerRate: Codable {
    let base: String
    let rates: [String: Double]
}
