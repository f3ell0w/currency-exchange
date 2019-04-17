//
//  String+Localized.swift
//  CurrencyExchange
//
//  Created by Namik Yaqubov on 17/04/2019.
//  Copyright © 2019 Namik Yaqubov. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
