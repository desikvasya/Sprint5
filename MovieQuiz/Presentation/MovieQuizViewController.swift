import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
           super.viewDidLoad()
           presenter = MovieQuizPresenter(viewController: self)
           imageView.layer.cornerRadius = 20
       }
    
    //MARK: - Actions
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
        yesButton.isEnabled = false
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
        noButton.isEnabled = false
    }
    
    //MARK: - Outlets
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet var yesButton: UIButton!
    @IBOutlet var noButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Private functions
    
    func showLoadingIndicator(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator(){
        activityIndicator.isHidden = true
    }
    
    func showNetworkError(message: String) {
            hideLoadingIndicator()

            let alert = UIAlertController(
                title: "Ошибка",
                message: message,
                preferredStyle: .alert)

                let action = UIAlertAction(title: "Попробовать ещё раз",
                style: .default) { [weak self] _ in
                    guard let self = self else { return }

                    self.presenter.restartGame()
                }

            alert.addAction(action)
        }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrectAnswer ? UIColor(named: "ypGreen")?.cgColor : UIColor(named: "ypRed")?.cgColor
        }
    
    func show(quiz step: QuizStepViewModel) {
            imageView.layer.borderColor = UIColor.clear.cgColor
            imageView.image = step.image
            textLabel.text = step.question
            counterLabel.text = step.questionNumber
            yesButton.isEnabled = true
            noButton.isEnabled = true
        }
    
    func show(quiz result: QuizResultsViewModel) {
            let message = presenter.makeResultsMessage()
            

            let alert = UIAlertController(
                title: result.title,
                message: message,
                preferredStyle: .alert)

                let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
                    guard let self = self else { return }

                    self.presenter.restartGame()
                }
            
            alert.view.accessibilityIdentifier = "Alert"

            alert.addAction(action)

            self.present(alert, animated: true, completion: nil)
        }
}
