import XCTest

final class MovieQuizUITests: XCTestCase {
    var app: XCUIApplication! //Эта переменная символизирует приложение, которое мы тестируем

    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        // это специальная настройка для тестов: если один тест не прошёл, то следующие тесты запускаться не будут
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func testYesButton() {
        let firstPoster = app.images["Poster"]
        let yesButton = app.buttons["Yes"]
        yesButton.tap()
        let secondPoster = app.images["Poster"]
        XCTAssertFalse(firstPoster == secondPoster)
        let indexLabel = app.staticTexts["Index"]
        sleep(3)
        XCTAssertTrue(indexLabel.label == "2/10")
    }
    
    func testNoButton() {
        let firstPoster = app.images["Poster"]
        let noButton = app.buttons["No"]
        noButton.tap()
        let secondPoster = app.images["Poster"]
        XCTAssertFalse(firstPoster == secondPoster)
        let indexLabel = app.staticTexts["Index"]
        sleep(3)
        XCTAssertTrue(indexLabel.label == "2/10")
    }
    
    func testGameFinish() {
        for _ in 1...10 {
            sleep(2)
            app.buttons["No"].tap()
            sleep(2)
        }
        
        sleep(2)
        
        let alert = app.alerts["Alert"]
        
        XCTAssertTrue(app.alerts["Alert"].exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
    }
    
    func testAlertDismiss() {
        for _ in 1...10 {
            sleep(2)
            app.buttons["No"].tap()
            sleep(2)

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
