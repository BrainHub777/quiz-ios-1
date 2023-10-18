import UIKit

final class MovieQuizViewController: UIViewController, AlertPresenterDelegate {
    
    
    // MARK: - Lifecycle
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLable: UILabel!
    @IBOutlet private weak var counterLablel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private var presenter: MovieQuizPresenter!
    private var alertPresenter: AlertPresenterProtocol!
    private var statisticService: StatisticService = StatisticServiceImplementation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //questionFactory.delegate = self
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(delegate: self)
        presenter.viewController = self
    }
    
    // MARK: - QuestionFactoryDelegate
    
    
    func didPresent(alert: UIAlertController?) {
        self.present(alert ?? UIAlertController(), animated: true, completion: nil)
    }
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
    
    // метод конвертации, который принимает моковый вопрос и возвращает вью модель для экрана вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        return QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(), question: model.text, questionNumber: "\(presenter.getCurrentQuestionIndex() + 1)/\(presenter.questionsAmount)")
    }
    // приватный метод вывода на экран вопроса, который принимает на вход вью модель вопроса и ничего не возвращает
    func show(quiz step: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLable.text = step.question
        counterLablel.text = step.questionNumber
    }
    
    func unblockButtons() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    // приватный метод, который меняет цвет рамки
    // принимает на вход булевое значение и ничего не возвращает
    func showAnswerResult(isCorrect: Bool) {
        presenter.didAnswer(isCorrectAnswer: isCorrect)
        imageView.layer.masksToBounds = true // 1
        imageView.layer.borderWidth = 8 // 2
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor // 3
        //correctAnswers = isCorrect ? correctAnswers + 1 : correctAnswers
        // запускаем задачу через 1 секунду c помощью диспетчера задач
        noButton.isEnabled = false
        yesButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { [weak self] in
            guard let self = self else { return }
            // код, который мы хотим вызвать через 1 секунду
            //self.presenter.correctAnswers = self.correctAnswers
            self.presenter.statisticService = self.statisticService
            self.presenter.alertPresenter = self.alertPresenter
            self.presenter.showNextQuestionOrResults()
            self.unblockButtons()
        }
    }
    
    // приватный метод, который содержит логику перехода в один из сценариев
    // метод ничего не принимает и ничего не возвращает
//    private func showNextQuestionOrResults() {
//        imageView.layer.borderColor = UIColor.clear.cgColor //очищаем рамку от цвета
//        if presenter.isLastQuestion() {
//            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
//            // идём в состояние "Результат квиза"
//            let completion: () -> Void = { [weak self] in
//                guard let self = self else { return }
//                presenter.resetQuestionIndex()
//                // сбрасываем переменную с количеством правильных ответов
//                self.correctAnswers = 0
//                
//                // заново показываем первый вопрос
//                self.questionFactory?.requestNextQuestion()
//            }
//            let model = AlertModel(title: "Этот раунд окончен!",
//                                   message: "Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)\n Количество сыгранных квизов: \(statisticService.gamesCount)\n Рекорд: \(statisticService.bestGame.correct)/\(presenter.questionsAmount) (\( statisticService.bestGame.date.dateTimeString))\n Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy * 100))%", buttonText: "Сыграть ещё раз", completion: completion)
//            alertPresenter.show(model: model)
//        } else {
//            presenter.switchToNextQuestion()
//            
//            questionFactory?.requestNextQuestion()
//            
//        }
//    }
    
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false // говорим, что индикатор загрузки не скрыт
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        // создайте и покажите алерт
        let model = AlertModel(title: "Ошибка",
                               message: message, buttonText: "Попробовать ещё раз", completion: { [weak self] in
            guard let self = self else { return }
            self.presenter.restartGame()
        })
        alertPresenter.show(model: model)
    }
    
    
}




// вью модель для состояния "Вопрос показан"


// для состояния "Результат квиза"


/*
 Mock-данные
 
 
 Картинка: The Godfather
 Настоящий рейтинг: 9,2
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Dark Knight
 Настоящий рейтинг: 9
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Kill Bill
 Настоящий рейтинг: 8,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Avengers
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Deadpool
 Настоящий рейтинг: 8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: The Green Knight
 Настоящий рейтинг: 6,6
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: ДА
 
 
 Картинка: Old
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: The Ice Age Adventures of Buck Wild
 Настоящий рейтинг: 4,3
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Tesla
 Настоящий рейтинг: 5,1
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 
 
 Картинка: Vivarium
 Настоящий рейтинг: 5,8
 Вопрос: Рейтинг этого фильма больше чем 6?
 Ответ: НЕТ
 */
