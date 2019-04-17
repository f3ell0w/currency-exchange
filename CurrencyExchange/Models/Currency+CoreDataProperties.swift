//
//  Currency+CoreDataProperties.swift
//  CurrencyExchange
//
//  Created by Namik Yaqubov on 18/04/2019.
//  Copyright © 2019 Namik Yaqubov. All rights reserved.
//
//

import Foundation
import CoreData

extension Currency {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Currency> {
        return NSFetchRequest<Currency>(entityName: "Currency")
    }

    @NSManaged public var code: String
    @NSManaged public var name: String

}
