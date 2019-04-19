//
//  CurrencyListTableViewController.swift
//  CurrencyExchange
//
//  Created by Namik Yaqubov on 17/04/2019.
//  Copyright © 2019 Namik Yaqubov. All rights reserved.
//

import UIKit

class RateListTableViewController: UITableViewController {

    private var rates: [Rate] = []
    
    private let refresher = UIRefreshControl()
    
    private lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "rates.empty".localized
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "title.rates".localized
        
        tableView.register(RateTableViewCell.self, forCellReuseIdentifier: RateTableViewCell.IDENTIFIER)
        tableView.tableFooterView = UIView.init(frame: .zero)
        tableView.refreshControl = refresher
        
        refresher.addTarget(self, action: #selector(onRefreshed), for: .valueChanged)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddTap))
        navigationItem.rightBarButtonItem = addButton
    }
    
    @objc private func onAddTap() {
        guard RateDataManager.shared.hasLoadedRates else {
            let alert = UIAlertController(title: nil, message: "update.dialog.message".localized, preferredStyle: .alert)
            let updateAction = UIAlertAction(title: "update.dialog.action".localized, style: .destructive) { [weak self] (_) in
                self?.updateRates()
            }
            let cancelAction = UIAlertAction(title: "dialog.dismiss".localized, style: .default, handler: nil)
            alert.addAction(cancelAction)
            alert.addAction(updateAction)
            present(alert, animated: true, completion: nil)
            return
        }
        let fromCurrencyController = FromCurrencyTableViewController()
        navigationController?.pushViewController(fromCurrencyController, animated: true)
    }
    
    @objc private func onRefreshed() {
        updateRates()
    }
    
    private func loadRates() {
        RateDataManager.shared.loadRates { [weak self] rates in
            guard let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.rates = rates
                self.checkIfEmpty()
                self.tableView.reloadData()
            }
        }
    }
    
    private func updateRates() {
        RateDataManager.shared.updateRates { [weak self] (result) in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let rates):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.refresher.endRefreshing()
                    self.rates = rates
                    self.tableView.reloadData()
                    self.showMessage("update.dialog.success".localized)
                })
            case .error(_):
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    self.refresher.endRefreshing()
                    self.showMessage("update.dialog.error".localized)
                })
            }
        }
    }
    
    private func checkIfEmpty() {
        if rates.isEmpty {
            tableView.backgroundView = emptyLabel
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rates.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RateTableViewCell.IDENTIFIER, for: indexPath) as! RateTableViewCell
        let rate = rates[indexPath.row]
        cell.configure(with: rate)
        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "rate.remove".localized) { (_, index) in
            let rate = self.rates[index.row]
            RateDataManager.shared.remove(rate, completion: { (result) in
                switch result {
                case .success(_):
                    self.rates.remove(at: index.row)
                    self.checkIfEmpty()
                    tableView.deleteRows(at: [index], with: .fade)
                case .error(_):
                    self.showMessage("rate.remove.error".localized)
                }
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
