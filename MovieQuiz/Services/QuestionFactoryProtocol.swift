//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Denis on 02.11.2022.
//

import Foundation
import UIKit

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func loadData()
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
    func didFailToLoadImage(with error: Error) // сообщение об ошибке загрузки картинки
//    func reloadImage()
}

