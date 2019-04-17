//
//  CurrencyDataManager.swift
//  CurrencyExchange
//
//  Created by Namik Yaqubov on 17/04/2019.
//  Copyright © 2019 Namik Yaqubov. All rights reserved.
//

import CoreData

class CurrencyDataManager {
    
    private static var shared: CurrencyDataManager?
    
    private let persistenceContainer: NSPersistentContainer
    
    private init(container: NSPersistentContainer) {
        self.persistenceContainer = container
    }
    
    class func initialize(container: NSPersistentContainer) {
        if shared == nil {
            shared = CurrencyDataManager(container: container)
            return
        }
        fatalError("Already initialized")
    }
    
    class func instance() -> CurrencyDataManager {
        if shared == nil {
            fatalError("Not initialized")
        }
        return shared!
    }
    
    func loadCurrencies() -> [Currency] {
        let context = persistenceContainer.viewContext
        let request: NSFetchRequest<Currency> = Currency.fetchRequest()
        do {
            var currencies = try context.fetch(request)
            if currencies.isEmpty {
                currencies = loadCurrenciesFromFile()
                try context.save()
            }
            return currencies
        } catch {
            return []
        }
    }
    
    func saveCurrency(code: String, name: String) {
        let context = persistenceContainer.viewContext
        let currency = Currency(context: context)
        currency.code = code
        currency.name = name
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func loadCurrenciesFromFile() -> [Currency] {
        let context = persistenceContainer.viewContext
        if let path = Bundle.main.path(forResource: "currencies", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let currencyStrings = data.components(separatedBy: .newlines)
                return currencyStrings.map { $0.split(separator: "-") }.map { (splitted) -> Currency in
                    let currency = Currency(context: context)
                    currency.code = splitted.first?.trimmingCharacters(in: .whitespaces) ?? ""
                    currency.name = splitted.last?.trimmingCharacters(in: .whitespaces) ?? ""
                    return currency
                }
            } catch {
                return []
            }
        }
        return []
    }
}
