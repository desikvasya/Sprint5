//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Denis on 03.12.2022.
//

import XCTest

class MovieQuizUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        app.terminate()
        app = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func screenTest() throws {
        
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testYesButton() {
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        
        sleep(3)
        
        app.buttons["Yes"].tap() // находим кнопку `Да` и нажимаем её
        
        let secondPoster = app.images["Poster"] // ещё раз находим постер
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster) // проверяем, что постеры разные
        
        
    }
    
    func testNoButton() {
        let firstPoster = app.images["Poster"] // находим первоначальный постер
        
        sleep(3)
        
        app.buttons["No"].tap() // находим кнопку `Да` и нажимаем её
        
        let secondPoster = app.images["Poster"] // ещё раз находим постер
        let indexLabel = app.staticTexts["Index"]
        
        sleep(3)
        
        XCTAssertTrue(indexLabel.label == "2/10")
        XCTAssertFalse(firstPoster == secondPoster) // проверяем, что постеры разные
    }
    
    func testGameFinish() {
        for _ in 1...10 {
            sleep(1)
            app.buttons["No"].tap()
            sleep(1)
        }
        
        sleep(2)
        
        let alert = app.alerts["Alert"]
        
        XCTAssertTrue(app.alerts["Alert"].exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть еще раз")
    }
    
    func testAlertDismiss() {
        for _ in 1...10 {
            sleep(1)
            app.buttons["No"].tap()
            sleep(1)
        }
        
        sleep(2)
        
        let alert = app.alerts["Alert"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(app.alerts["Alert"].exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
