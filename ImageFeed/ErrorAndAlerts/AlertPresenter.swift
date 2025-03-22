//
//  AlertPresenter.swift
//  ImageFeed
//
//  Created by Алина on 22.03.2025.
//

import UIKit

final class AlertPresenter {
    
    static let notificationsAlert = AlertPresenter()
    private init(){}
    
    func showAlert(on viewController: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
    
}
