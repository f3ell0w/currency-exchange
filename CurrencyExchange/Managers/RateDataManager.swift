//
//  RateDataManager.swift
//  CurrencyExchange
//
//  Created by Namik Yaqubov on 17/04/2019.
//  Copyright © 2019 Namik Yaqubov. All rights reserved.
//

import CoreData

class RateDataManager {
    
    private static var shared: RateDataManager?
    private static let BASE_CURRENCY = "EUR"
    
    private let persistenceContainer: NSPersistentContainer
    
    private init(container: NSPersistentContainer) {
        self.persistenceContainer = container
    }
    
    class func initialize(container: NSPersistentContainer) {
        if shared == nil {
            shared = RateDataManager(container: container)
            return
        }
        fatalError("Already initialized")
    }
    
    class func instance() -> RateDataManager {
        if shared == nil {
            fatalError("Not initialized")
        }
        return shared!
    }
    
    func loadRates() -> [Rate] {
        let context = persistenceContainer.viewContext
        let request: NSFetchRequest<Rate> = Rate.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    func saveRate(fromCur: Currency, toCur: Currency, completion: (() -> Void)?) {
        let context = persistenceContainer.viewContext
        let rate = Rate(context: context)
        rate.from = fromCur
        rate.to = toCur
        rate.rate = calculateRate(from: fromCur, to: toCur)
        do {
            try context.save()
            completion?()
        } catch {
            dump(error)
        }
    }
    
    func remove(_ rate: Rate, completion: (() -> Void)?) {
        let context = persistenceContainer.viewContext
        do {
            context.delete(rate)
            try context.save()
            completion?()
        } catch {
            print(error)
        }
    }
    
    private func calculateRate(from fromCur: Currency, to toCur: Currency) -> Double {
        // @FIXME
        var rate: Double = 1.0
        if fromCur == toCur {
            rate = 1.0
        } else if toCur.code == RateDataManager.BASE_CURRENCY {
            rate = 1 / 1.5
        } else if fromCur.code == RateDataManager.BASE_CURRENCY {
            rate = 1.5
        } else {
            rate = 1.5 / 1.4
        }
        return round(rate * 1.5 * 100) / 100
    }
}
