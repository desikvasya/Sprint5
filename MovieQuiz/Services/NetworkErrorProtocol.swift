//
//  NetworkErrorProtocol.swift
//  MovieQuiz
//
//  Created by Denis on 16.11.2022.
//

import Foundation

protocol NetworkErrorProtocol {
    func showNetworkError(quiz result: NetworkErrorModel)
}
