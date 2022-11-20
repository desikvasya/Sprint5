//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Denis on 30.10.2022.
//

import Foundation
import UIKit

class QuestionFactory: QuestionFactoryProtocol {
    var index = 0
    private var movies:[MostPopularMovie] = []
    private let moviesLoader: MoviesLoading
    private var delegate: QuestionFactoryDelegate?
    
    init(delegate:QuestionFactoryDelegate?, moviesLoader: MoviesLoading){
        self.delegate = delegate
        self.moviesLoader = moviesLoader
    }
    
    func loadData() {
        moviesLoader.loadMovies { result in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async {
            [weak self] in guard let self = self else {return}
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies [safe:index] else {return}
            
            var imageData = Data()
            
            do{
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("failed to load image")
            }
            let rating = Float(movie.rating) ?? 0
            let currentRating = (4...9).randomElement()
            
            let text = "Рейтинг этого фильма больше чем \(currentRating ?? 5)?"
            let correctAnswer = rating > Float(currentRating ?? 5)
            
            let question = QuizQuestion(
                image: imageData,
                text: text,
                correctAnswer: correctAnswer)
            
            DispatchQueue.main.async {
                [weak self] in
                guard let self = self else {return}
                self.delegate?.didRecieveNextQuestion(question: question)
            }
        }
    }
    func resetIndex(){
        index = 0
    }
}








//    var questions: [QuizQuestion] = [
//        QuizQuestion(
//            image: "The Godfather",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Dark Knight",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Kill Bill",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Avengers",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Deadpool",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "The Green Knight",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: true),
//        QuizQuestion(
//            image: "Old",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "The Ice Age Adventures of Buck Wild",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "Tesla",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false),
//        QuizQuestion(
//            image: "Vivarium",
//            text: "Рейтинг этого фильма больше чем 6?",
//            correctAnswer: false)
//    ]
//
//    func questionShuffle(){
//        questions.shuffle()
//    }

//    func requestNextQuestion(){
//        guard let index = (0..<questions.count).randomElement() else {
//            delegate?.didRecieveNextQuestion(question: nil)
//            return
//        }
//        let question = questions[safe: index]
//        delegate?.didRecieveNextQuestion(question: question)
//    }


