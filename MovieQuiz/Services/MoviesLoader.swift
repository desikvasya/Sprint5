//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Denis on 19.11.2022.
//

import Foundation

protocol MoviesLoading {
    func loadMovies (handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoading {
    private let networkClient = NetworkClient()
    
    private var mostPopularMoviesUrl: URL {
        guard let url = URL(string: "https://imdb-api.com/en/API/Top250Movies/k_lkq163dk") else {
            preconditionFailure("Unable to construct mostPopularMoviesUrl")
        }
        return url
    }
    
    private enum DecodeError: Error {
           case codeError
       }
    
    func loadMovies (handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
            case.failure(let error) : handler(.failure(error))
            case.success(let data) :
                let topMovieList = try? JSONDecoder().decode(MostPopularMovies.self, from: data)
                if let topMovieList = topMovieList {
                                    handler(.success(topMovieList)) } else {
                                        handler(.failure(DecodeError.codeError))
                    }
                }
            }
        }

}
