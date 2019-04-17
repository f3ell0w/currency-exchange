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
        
        currencies = CurrencyDataManager.instance().loadCurrencies()
        
        tableView.register(CurrencyTableViewCell.self, forCellReuseIdentifier: "currency")
        tableView.tableFooterView = UIView.init(frame: .zero)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currency", for: indexPath) as! CurrencyTableViewCell
        let currency = currencies[indexPath.row]
        cell.configure(with: currency)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = currencies[indexPath.row]
        RateDataManager.instance().saveRate(fromCur: fromCurrency, toCur: currency, completion: {
            self.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "title.second.currency".localized
    }
}
