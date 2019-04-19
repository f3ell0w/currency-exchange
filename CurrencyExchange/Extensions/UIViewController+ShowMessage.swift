//
//  UIViewController+ShowMessage.swift
//  CurrencyExchange
//
//  Created by Namik Yaqubov on 19/04/2019.
//  Copyright © 2019 Namik Yaqubov. All rights reserved.
//

import UIKit

extension UIViewController {
    func showMessage(_ message: String?) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "dialog.dismiss".localized, style: .default, handler: nil)
        alert.addAction(dismissAction)
        present(alert, animated: true, completion: nil)
    }
}
