//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Дмитрий Бучнев on 24.09.2023.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {               // 1
    func didReceiveNextQuestion(question: QuizQuestion?)    // 2
}
