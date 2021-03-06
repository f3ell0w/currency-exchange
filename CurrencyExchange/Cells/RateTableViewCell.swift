//
//  RateTableViewCell.swift
//  CurrencyExchange
//
//  Created by Namik Yaqubov on 17/04/2019.
//  Copyright © 2019 Namik Yaqubov. All rights reserved.
//

import UIKit

class RateTableViewCell: UITableViewCell {
    
    static let IDENTIFIER = "rate"
    
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
    
    private lazy var leftStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [nomineeLabel, nomineeNameLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var rightStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [valueLabel, secondNomineeLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        addSubview(leftStack)
        addSubview(rightStack)
        
        let leftStackConstraints = [
            leftStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            leftStack.rightAnchor.constraint(equalTo: rightStack.leftAnchor, constant: -16),
            leftStack.topAnchor.constraint(equalTo: topAnchor),
            leftStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        let rightStackConstraints = [
            rightStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            rightStack.topAnchor.constraint(equalTo: topAnchor),
            rightStack.bottomAnchor.constraint(equalTo: bottomAnchor)
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
