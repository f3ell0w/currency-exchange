//
//  ToCurrencyTableViewController.swift
//  CurrencyExchange
//
//  Created by Namik Yaqubov on 17/04/2019.
//  Copyright © 2019 Namik Yaqubov. All rights reserved.
//

import UIKit

class ToCurrencyTableViewController: UITableViewController {

    var fromCurrency: Currency!
    
    private var currencies: [Currency] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: CurrencyTableViewCell.IDENTIFIER)
        tableView.tableFooterView = UIView.init(frame: .zero)
        
        let localCurrencies = CurrencyDataManager.shared.loadCurrencies().filter { $0.code != fromCurrency.code }
        currencies = localCurrencies
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyTableViewCell.IDENTIFIER, for: indexPath) as! CurrencyTableViewCell
        let currency = currencies[indexPath.row]
        cell.configure(with: currency)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = currencies[indexPath.row]
        RateDataManager.shared.saveRate(from: fromCurrency, to: currency) { (result) in
            switch result {
            case .success(_):
                self.navigationController?.popToRootViewController(animated: true)
            case .error(_):
                self.showMessage("rate.save.error".localized)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "title.second.currency".localized
    }
}
