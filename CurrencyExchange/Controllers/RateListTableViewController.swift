//
//  CurrencyListTableViewController.swift
//  CurrencyExchange
//
//  Created by Namik Yaqubov on 17/04/2019.
//  Copyright © 2019 Namik Yaqubov. All rights reserved.
//

import UIKit

class RateListTableViewController: UITableViewController {

    private var rates: [Rate] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "title.rates".localized
        
        tableView.register(RateTableViewCell.self, forCellReuseIdentifier: "rate")
        tableView.tableFooterView = UIView.init(frame: .zero)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTap))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc
    private func onAddTap() {
        let fromCurrencyController = FromCurrencyTableViewController()
        navigationController?.pushViewController(fromCurrencyController, animated: true)
    }
    
    private func loadRates() {
        rates = RateDataManager.instance().loadRates()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rate", for: indexPath) as! RateTableViewCell
        let rate = rates[indexPath.row]
        cell.configure(with: rate)
        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "rate.remove".localized) { (_, index) in
            let rate = self.rates[index.row]
            RateDataManager.instance().remove(rate, completion: {
                self.rates.remove(at: index.row)
                // @FIXME
                tableView.deleteRows(at: [index], with: .fade)
            })
        }
        return [delete]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadRates()
    }
}
