////
////  AlertPresenter.swift
////  MovieQuiz
////
////  Created by Denis on 05.11.2022.
////
//
//import Foundation
//import UIKit
//
//struct AlertPresenter {
//    var correctAnswers: Int = 0
//
//    let viewModel = AlertModel (title: "Этот раунд окончен",
//                                         text: "Ваш результат: \(correctAnswers) из 10",
//                                         record: text,
//                                         accuracy: text,
//                                         buttonText: "Сыграть еще раз")
//    
//     func show(quiz result: QuizResultsViewModel) {
//        let alert = UIAlertController(title: result.title,
//                                      message: result.text,
//                                      preferredStyle: .alert)
//        let action = UIAlertAction(title: result.buttonText, style: .default)
//        { [weak self] _ in
//            guard let self = self else {return}
//            
//            self.currentQuestionIndex = 0
//            self.correctAnswers = 0
//            
//            
//        }
//        alert.addAction(action)
//        self.present(alert, animated: true, completion: nil)
//    }
//}
