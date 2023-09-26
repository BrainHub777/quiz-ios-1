//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Дмитрий Бучнев on 26.09.2023.
//

import Foundation
import UIKit

class AlertPresenter: AlertPresenterProtocol {
    
    weak var delegate: AlertPresenterDelegate?
    private var alert: UIAlertController?
    private var action: UIAlertAction?
    
    func createAlert(model: AlertModel) {
        alert = UIAlertController(
            title: model.title,
            message: model.message,
            preferredStyle: .alert)
        
        action = UIAlertAction(title: model.buttonText, style: .default) {_ in 
            model.completion()
        }
        
        alert?.addAction(action ?? UIAlertAction())
    
        //self.present(alert, animated: true, completion: nil)
        delegate?.didPresent(alert: alert)
    }
}