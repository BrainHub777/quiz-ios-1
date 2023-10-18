import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textLable: UILabel!
    @IBOutlet private weak var counterLablel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    private var presenter: MovieQuizPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
    }
    
    func show(quiz step: QuizStepViewModel) {
        unblockButtons()
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = step.image
        textLable.text = step.question
        counterLablel.text = step.questionNumber
    }
    
    func blockButtons() {
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    func unblockButtons() {
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func presentAlert(alert: UIAlertController?) {
        self.present(alert ?? UIAlertController(), animated: true, completion: nil)
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
}
