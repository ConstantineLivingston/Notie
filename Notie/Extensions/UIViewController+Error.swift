//
//  UIViewController+Error.swift
//  Notie
//
//  Created by Konstantin Bratchenko on 29.11.2022.
//

import UIKit

extension UIViewController {
    func showError(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
