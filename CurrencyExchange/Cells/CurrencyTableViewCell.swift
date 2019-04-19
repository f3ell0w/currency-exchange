//
//  CurrencyTableViewCell.swift
//  CurrencyExchange
//
//  Created by Namik Yaqubov on 17/04/2019.
//  Copyright © 2019 Namik Yaqubov. All rights reserved.
//

import UIKit

class CurrencyTableViewCell: UITableViewCell {

    static let IDENTIFIER = "currency"
    
    private lazy var codeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(codeLabel)
        addSubview(nameLabel)
        
        nameLabel.setContentHuggingPriority(UILayoutPriority.init(249), for: .horizontal)
        
        let codeLabelConstraints = [
            codeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            codeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            codeLabel.widthAnchor.constraint(equalToConstant: 40)
        ]
        let nameLabelConstraints = [
            nameLabel.leftAnchor.constraint(equalTo: codeLabel.rightAnchor, constant: 16),
            nameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(codeLabelConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
    }
    
    func configure(with currency: Currency) {
        codeLabel.text = currency.code
        nameLabel.text = currency.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
