//
//  CurrencyDataManager.swift
//  CurrencyExchange
//
//  Created by Namik Yaqubov on 17/04/2019.
//  Copyright © 2019 Namik Yaqubov. All rights reserved.
//

import CoreData

class CurrencyDataManager {
    
    private static var instance: CurrencyDataManager?
    
    private let persistenceContainer: NSPersistentContainer
    
    private init(container: NSPersistentContainer) {
        self.persistenceContainer = container
    }
    
    class func initialize(_ container: NSPersistentContainer) {
        if instance == nil {
            instance = CurrencyDataManager(container: container)
            return
        }
        fatalError("Already initialized")
    }
    
    static var shared: CurrencyDataManager {
        get {
            if instance == nil {
                fatalError("Not initialized")
            }
            return instance!
        }
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

    private func loadCurrenciesFromFile() -> [Currency] {
        let context = persistenceContainer.viewContext
        if let path = Bundle.main.path(forResource: "currencies", ofType: "txt") {
            do {
                let data = try String(contentsOfFile: path, encoding: .utf8)
                let currencyStrings = data.components(separatedBy: .newlines)
                return currencyStrings.map { $0.split(separator: "-")
                    .map { $0.trimmingCharacters(in: .whitespaces) } }
                    .filter { !$0.isEmpty }
                    .map { (splitted) -> Currency in
                        let currency = Currency(context: context)
                        currency.code = splitted.first ?? ""
                        currency.name = splitted.last ?? ""
                        return currency
                    }
            } catch {
                return []
            }
        }
        return []
    }
}
