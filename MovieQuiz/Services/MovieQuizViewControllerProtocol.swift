//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Дмитрий Бучнев on 18.10.2023.
//

import Foundation
import UIKit


protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func blockButtons()
    func unblockButtons()
    func presentAlert(alert: UIAlertController?)
}
