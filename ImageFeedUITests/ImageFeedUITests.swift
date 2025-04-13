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
        loginTextField.typeText("test@mail.ru")
        
        passwordTextField.tap()
        passwordTextField.typeText("password")
        
        webView.swipeUp()
    }
    
    @MainActor
    func testFeed() throws {
        // тестируем сценарий ленты
    }
    
    @MainActor
    func testProfile() throws {
        // тестируем сценарий профиля
    }
}



//        print(app.debugDescription)
