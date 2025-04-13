//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Алина on 12.04.2025.
//

import XCTest

final class ImageFeedUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        app.terminate()
        app = nil
    }
    
    func testAuth() throws {
        let activeButton = app.buttons["Authenticate"]
        XCTAssertTrue(activeButton.waitForExistence(timeout: 5), "Кнопка 'Login' не появилась на экране")
        activeButton.tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 5), "WebView не загрузился")
        
        let loginTextField = webView.descendants(matching: .textField).element
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 10), "Поле для логина не найдено")
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 10), "Поле для пароля не найдено")
        
        loginTextField.tap()
        XCTAssertTrue(app.keyboards.element.waitForExistence(timeout: 10), "Клавиатура не появилась после тап по логину")
        loginTextField.typeText("")
        
        Thread.sleep(forTimeInterval: 5)
        
        passwordTextField.tap()
        XCTAssertTrue(app.keyboards.element.waitForExistence(timeout: 10), "Клавиатура не появилась после тап по паролю")
        passwordTextField.typeText("")
        
        Thread.sleep(forTimeInterval: 5)
        
        webView.swipeUp()
        
        Thread.sleep(forTimeInterval: 5)
        
        webView.buttons["Login"].tap()
        
        Thread.sleep(forTimeInterval: 5)
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 10), "Ячейка не появилась — возможно, не загрузилась лента")
    }
    
    @MainActor
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        Thread.sleep(forTimeInterval: 5)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        
        let likeButtonOff = cellToLike.buttons["No Active"]
        let likeButtonOn = cellToLike.buttons["Active"]
        
        XCTAssertTrue(likeButtonOff.exists)
        likeButtonOff.tap()
        
//        cellToLike.buttons["No Active"].tap()
        Thread.sleep(forTimeInterval: 5)
        
//        cellToLike.buttons["Active"].tap()
        XCTAssertTrue(likeButtonOn.exists)
        Thread.sleep(forTimeInterval: 3)
        likeButtonOn.tap()
        
//        cellToLike.tap()
        Thread.sleep(forTimeInterval: 3)
        
        cellToLike.tap()
        Thread.sleep(forTimeInterval: 3)
        
        
        let image = app.scrollViews.images.element(boundBy: 0)
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
    
        let navBackButtonWhiteButton = app.buttons["navBackButtonWhite"]
        navBackButtonWhiteButton.tap()
    }
    
    @MainActor
    func testProfile() throws {
        // тестируем сценарий профиля
    }
}



//        print(app.debugDescription)
