import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    private let presenter = MovieQuizPresenter()
    
    //    func didFailToLoadImage(with error: Error) {
    //        questionFactory?.reloadImage()
    //        reloadImageButton.isHidden = false
    //
    //    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        questionFactory?.requestNextQuestion()
        
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
        
    }
    
    func didRecieveNextQuestion(question: QuizQuestion?) {
        presenter.didRecieveNextQuestion(question: question)
    }
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.layer.cornerRadius = 20
        view.layer.backgroundColor = UIColor.ypBlack.cgColor
        
        presenter.viewController = self
        
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        statisticService = StatisticServiceImplementation()
        showLoadingIndicator()
        questionFactory?.loadData()
        
        
        questionFactory?.requestNextQuestion()
        alertPresenter = AlertPresenter(viewController: self)
        //        reloadImageButton.isHidden = true
    }
    
    private var correctAnswers: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenter?
    private var statisticService: StatisticService!
    
    
    //MARK: - Actions
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    //    @IBAction private func reloadImage(_ sender: UIButton) {
    //        questionFactory?.reloadImage()
    //        reloadImageButton.isHidden = true
    //    }
    
    //MARK: - Outlets
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private var yesButton: UIButton!
    @IBOutlet private var noButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //    @IBOutlet weak var reloadImageButton: UIButton!
    
    private func showLoadingIndicator(){
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator(){
        activityIndicator.isHidden = true
    }
    
    
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        self.presenter.resetQuestionIndex()
        self.correctAnswers = 0
        
        let errorModel = UIAlertController(title: "Что-то пошло не так(", message: message, preferredStyle: .alert)
        errorModel.addAction(UIAlertAction(title: "Попробуйте еще раз", style: .default) { action in
            self.questionFactory?.loadData()
            self.questionFactory?.requestNextQuestion()
            self.showLoadingIndicator()
        })
        self.present(errorModel, animated: true, completion: nil)
        
    }
    
     func show(quiz step: QuizStepViewModel) {
        // здесь мы заполняем нашу картинку, текст и счётчик данными
        UIView.animate(withDuration: 1.0,
                       animations: {
            self.imageView.image = step.image
        },
                       completion: { [weak self] _ in
            self?.yesButton.isEnabled = true
            self?.noButton.isEnabled = true
        }
        )
        
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
    
    func show(quiz result: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: result.title,
            message: result.text,
            buttonText: result.buttonText)
        { [weak self] _ in
            guard let self = self else { return }
            self.correctAnswers = 0
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.showAlert(quiz: alertModel)
    }
    
    func showAnswerResult(isCorrect: Bool) {
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        imageView.layer.cornerRadius = 20
        
        //        noButton.isEnabled = false
        //        yesButton.isEnabled = false
        
        if isCorrect {
            correctAnswers += 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
                    guard let self = self else { return }
                    self.presenter.correctAnswers = self.correctAnswers
                    self.presenter.questionFactory = self.questionFactory
                    self.presenter.showNextQuestionOrResults()
                }
    }
    
    
    private func showNextQuestionOrResults(){
        if presenter.isLastQuestion() {
            statisticService.store(correct: correctAnswers, total: presenter.questionsAmount)
            let text = """
                                   Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
                                   Количество сыгранных квизов: \(statisticService.gamesCount)
                                   Рекорд: \(statisticService.bestGame.toString())
                                   Средняя точность: \(Int(statisticService.totalAccuracy))%
                                   """
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть еще раз")
            
            self.correctAnswers = 0
            show(quiz: viewModel)
        } else {
            presenter.switchToNextQuestion()
            questionFactory?.requestNextQuestion()
        }
    }
    
}
