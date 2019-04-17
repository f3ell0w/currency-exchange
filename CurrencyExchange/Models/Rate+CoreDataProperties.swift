//
//  Rate+CoreDataProperties.swift
//  CurrencyExchange
//
//  Created by Namik Yaqubov on 18/04/2019.
//  Copyright © 2019 Namik Yaqubov. All rights reserved.
//
//

import Foundation
import CoreData

extension Rate {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Rate> {
        return NSFetchRequest<Rate>(entityName: "Rate")
    }

    @NSManaged public var rate: Double
    @NSManaged public var from: Currency
    @NSManaged public var to: Currency

}
