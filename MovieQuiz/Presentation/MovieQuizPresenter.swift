//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Дмитрий Бучнев on 17.10.2023.
//

import Foundation
import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
   var questionFactory: QuestionFactoryProtocol?
    var alertPresenter: AlertPresenterProtocol?
    var statisticService: StatisticService!
    var correctAnswers = 0
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
        //statisticService = StatisticServiceImplementation()
        //alertPresenter = AlertPresenter(delegate: self)
        //questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
    }
    

    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func getCurrentQuestionIndex() -> Int {
        return self.currentQuestionIndex
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(), question: model.text, questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let givenAnswer = isYes

        viewController?.showAnswerResult(isCorrect: givenAnswer == currentQuestion.correctAnswer)
    }
    
     func didAnswer(isCorrectAnswer: Bool) {
        correctAnswers = isCorrectAnswer ? correctAnswers + 1 : correctAnswers
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        let message = error.localizedDescription
        viewController?.showNetworkError(message: message)
    }
    
    func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            statisticService?.store(correct: self.correctAnswers, total: self.questionsAmount)
            // идём в состояние "Результат квиза"
            let completion: () -> Void = { [weak self] in
                guard let self = self else { return }
                self.restartGame()
            }
            let model = AlertModel(title: "Этот раунд окончен!",
                                   message: "Ваш результат: \(correctAnswers)/\(self.questionsAmount)\n Количество сыгранных квизов: \(statisticService.gamesCount)\n Рекорд: \(statisticService.bestGame.correct)/\(self.questionsAmount) (\( statisticService.bestGame.date.dateTimeString))\n Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy * 100))%", buttonText: "Сыграть ещё раз", completion: completion)
            alertPresenter?.show(model: model)
        } else {
            self.switchToNextQuestion()
            
            questionFactory?.requestNextQuestion()
            
        }
        
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }

    
        
}
