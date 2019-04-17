//
//  RateTableViewCell.swift
//  CurrencyExchange
//
//  Created by Namik Yaqubov on 17/04/2019.
//  Copyright © 2019 Namik Yaqubov. All rights reserved.
//

import UIKit

class RateTableViewCell: UITableViewCell {
    
    private lazy var nomineeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var nomineeNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var secondNomineeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let leftStack = UIStackView(arrangedSubviews: [nomineeLabel, nomineeNameLabel])
        leftStack.axis = .vertical
        leftStack.distribution = .fillProportionally
        leftStack.translatesAutoresizingMaskIntoConstraints = false
        
        let rightStack = UIStackView(arrangedSubviews: [valueLabel, secondNomineeLabel])
        rightStack.axis = .vertical
        rightStack.distribution = .fillProportionally
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(leftStack)
        addSubview(rightStack)
        
        let leftStackConstraints = [
            leftStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            leftStack.rightAnchor.constraint(equalTo: rightStack.leftAnchor, constant: -16),
            leftStack.heightAnchor.constraint(equalToConstant: 80)
        ]
        let rightStackConstraints = [
            rightStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            rightStack.heightAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(rightStackConstraints)
        NSLayoutConstraint.activate(leftStackConstraints)
    }
    
    func configure(with rate: Rate) {
        nomineeLabel.text = "1 \(rate.from.code)"
        nomineeNameLabel.text = rate.from.name
        valueLabel.text = "\(rate.rate)"
        secondNomineeLabel.text = "\(rate.to.name) • \(rate.to.code)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
