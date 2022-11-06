//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Denis on 03.11.2022.
//

import Foundation
import UIKit

protocol QuestionFactoryDelegate: class {                   // 1
    func didRecieveNextQuestion(question: QuizQuestion?)   // 2
}
