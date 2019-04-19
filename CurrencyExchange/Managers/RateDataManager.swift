//
//  RateDataManager.swift
//  CurrencyExchange
//
//  Created by Namik Yaqubov on 17/04/2019.
//  Copyright © 2019 Namik Yaqubov. All rights reserved.
//

import CoreData

enum AppError: Error {
    case httpError
    case generalError
}

enum Result<T> {
    case success(T)
    case error(AppError)
}

typealias UpdateHandler = ((Result<[Rate]>) -> Void)
typealias SaveHandler = ((Result<()>) -> Void)
typealias RemoveHandler = ((Result<()>) -> Void)

class RateDataManager {
    
    private static var instance: RateDataManager?
    private static let BASE_CURRENCY = "EUR"
    private static let BASE_URL = "http://data.fixer.io/api/latest?access_key=66253c6625f8abe18cd9c4be62bee198&format=1"
    private static let CACHED_RATE_KEY = "CACHED_RATE"
    
    var hasLoadedRates = false
    
    private var serverRate: ServerRate = ServerRate(base: "EUR", rates: [:])
    
    private let persistenceContainer: NSPersistentContainer
    private let session: URLSession
    
    private init(container: NSPersistentContainer) {
        self.persistenceContainer = container
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringCacheData
        config.urlCache = nil
        self.session = URLSession.init(configuration: config)
        
        guard let cachedRate = getCachedRate() else {
            self.hasLoadedRates = false
            return
        }
        self.hasLoadedRates = true
        self.serverRate = cachedRate
    }
    
    class func initialize(_ container: NSPersistentContainer) {
        if instance == nil {
            instance = RateDataManager(container: container)
            return
        }
        fatalError("Already initialized")
    }
    
    static var shared: RateDataManager {
        get {
            if instance == nil {
                fatalError("Not initialized")
            }
            return instance!
        }
    }

    func loadRates(_ completion: (([Rate]) -> Void)) {
        let context = persistenceContainer.viewContext
        let request: NSFetchRequest<Rate> = Rate.fetchRequest()
        do {
            let rates = try context.fetch(request)
            completion(rates)
        } catch {
            completion([])
        }
    }
    
    func saveRate(from fromCur: Currency, to toCur: Currency, completion: RemoveHandler) {
        let context = persistenceContainer.viewContext
        let rate = Rate(context: context)
        rate.from = fromCur
        rate.to = toCur
        rate.rate = calculateRate(serverRate, from: fromCur, to: toCur)
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.error(.generalError))
        }
    }
    
    func remove(_ rate: Rate, completion: RemoveHandler) {
        let context = persistenceContainer.viewContext
        do {
            context.delete(rate)
            try context.save()
            completion(.success(()))
        } catch {
            completion(.error(.generalError))
        }
    }
    
    func loadServerRatesIfNeeded() {
        guard let _ = getCachedRate() else {
            loadServerRates()
            return
        }
        hasLoadedRates = true
    }
    
    func updateRates(_ completion: @escaping UpdateHandler) {
        loadServerRates { (result) in
            switch result {
            case .success(let serverRate):
                self.loadRates { (localRates) in
                    localRates.forEach { (rate) in
                        rate.rate = self.calculateRate(serverRate, from: rate.from, to: rate.to)
                    }
                    completion(.success(localRates))
                }
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    private func loadServerRates(_ handler: ((Result<ServerRate>) -> Void)? = nil) {
        let url = URL(string: RateDataManager.BASE_URL)!
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                handler?(.error(.httpError))
                return
            }
            guard let data = data else {
                handler?(.error(.httpError))
                return
            }
            
            if let serverRate = try? JSONDecoder().decode(ServerRate.self, from: data) {
                UserDefaults.standard.set(String(data: data, encoding: String.Encoding.utf8), forKey: RateDataManager.CACHED_RATE_KEY)
                self.hasLoadedRates = true
                self.serverRate = serverRate
                handler?(.success(serverRate))
            } else {
                self.hasLoadedRates = false
                handler?(.error(.httpError))
            }
        }
        task.resume()
    }
    
    private func getCachedRate() -> ServerRate? {
        if let cachedRates = UserDefaults.standard.string(forKey: RateDataManager.CACHED_RATE_KEY) {
            let data = cachedRates.data(using: .utf8)!
            return try? JSONDecoder().decode(ServerRate.self, from: data)
        }
        return nil
    }
    
    private func calculateRate(_ serverRate: ServerRate, from fromCur: Currency, to toCur: Currency) -> Double {
        guard let toCurRate = serverRate.rates[toCur.code], let fromCurRate = serverRate.rates[fromCur.code] else {
            return -1.0
        }
        var rate: Double = 1.0
        if fromCur.code == toCur.code {
            rate = 1.0
        } else if toCur.code == RateDataManager.BASE_CURRENCY {
            rate = 1 / fromCurRate
        } else if fromCur.code == RateDataManager.BASE_CURRENCY {
            rate = toCurRate
        } else {
            rate = toCurRate / fromCurRate
        }
        return round(rate * 100) / 100
    }
}
