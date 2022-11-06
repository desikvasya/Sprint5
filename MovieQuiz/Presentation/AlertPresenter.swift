//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Denis on 05.11.2022.
//

import Foundation
import UIKit

struct AlertPresenter{
    
    var delegate: AlertProtocol?
    init(delegate: AlertProtocol?) {
        self.delegate = delegate
    }
    
    weak var viewController: UIViewController?
    
    struct AlertPresenter {
        
        weak var viewController: UIViewController?
        func showAlert(quiz result: AlertModel) {
            
            let alert = UIAlertController(
                title: result.title,
                message: result.message,
                preferredStyle: .alert)
            
            let action = UIAlertAction(
                title: result.buttonText,
                style: .default)

            alert.addAction(action)
            viewController?.present(alert, animated: true)
        }

    }
}
