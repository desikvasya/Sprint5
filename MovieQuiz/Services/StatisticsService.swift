//
//  StatisticsService.swift
//  MovieQuiz
//
//  Created by Denis on 12.11.2022.
//

import Foundation


protocol StatisticService {
    func store(correct count: Int, total amount: Int)
    var totalAccuracy: Double { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }
}

struct GameRecord: Codable, Comparable {
    let correct: Int
    let total: Int
    let date: Date
    
    static func < (oldValue: GameRecord, newValue: GameRecord) -> Bool {
        return oldValue.correct < newValue.correct
    }
    
    func toString() -> String {
        return "\(correct)/\(total) (\(date.dateTimeString))"
    }
}

class StatisticServiceImplementation: StatisticService {
    
    var totalAccuracy: Double {
        let correctStored = userDefaults.double(forKey: Keys.correct.rawValue)
        let totalStored = userDefaults.double(forKey: Keys.total.rawValue)
        return (correctStored / totalStored) * 100
    }
    
    private let jsonEncoder = JSONEncoder()
    private let jsonDecoder = JSONDecoder()
    private let userDefaults = UserDefaults.standard
    
    func store(correct count: Int, total amount: Int) {
        let currentGameResults = GameRecord(correct: count, total: amount, date: Date())
        
        if self.bestGame < currentGameResults {
            self.bestGame = currentGameResults
        }
        
        let correctStored = userDefaults.integer(forKey: Keys.correct.rawValue)
        userDefaults.set(correctStored + count, forKey: Keys.correct.rawValue)
        
        let totalStored = userDefaults.integer(forKey: Keys.total.rawValue)
        userDefaults.set(totalStored + amount, forKey: Keys.total.rawValue)
        
        gamesCount += 1
        //        1) В классе StatisticServiceImplementation очень много дублируюещегося кода. Вместо того чтобы внутри store обращаться к userDafaults вот так userDefaults.set(gamesCount + 1, forKey: Keys.gamesCount.rawValue), можно сделать вот так gamesCount += 1 – ведь переменная gamesCount, уже содержит необходимые геттеры и сеттеры через userDefaults. Тоже самое можно сделать и для свойств correct, count
        //        2) Можно не создавать JSONDecoder() и енкодер в bestGame, ведь уже заведены переменные jsonEncoder/jsonDecoder, можно использовать их.
        //        Подскажи пожалуйста как этот синтаксис правильно называется и где можно больше прочитать чтобы лучше понять ? Спасибо
    }
    
    var bestGame: GameRecord {
        get {
            guard let data = userDefaults.data(forKey: Keys.bestGame.rawValue),
                  let record = try? JSONDecoder().decode(GameRecord.self, from: data) else {
                return .init(correct: 0, total: 0, date: Date())
            }
            return record
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            userDefaults.set(data, forKey: Keys.bestGame.rawValue)
        }
    }
    
    
    
    var gamesCount: Int {
        get {
            userDefaults.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    
    
    
    
    private enum Keys: String {
        case correct, total, bestGame, gamesCount, totalAccuracy, accuracy
    }
    
}
