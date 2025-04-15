//
//  ImagesListViewControllerTests.swift
//  ImageFeed
//
//  Created by Алина on 15.04.2025.
//
import XCTest
@testable import ImageFeed

import XCTest
@testable import ImageFeed

class ImagesListViewControllerTests: XCTestCase {
    
    var viewController: ImagesListViewController!
    var mockView: MockImagesListViewControllerProtocol!
    
    override func setUp() {
        super.setUp()
        
        // Создаем мок для ImagesListViewControllerProtocol
        mockView = MockImagesListViewControllerProtocol()
        
        // Инициализируем контроллер
        viewController = ImagesListViewController()
        
        // Присваиваем презентер с моком
        let mockPresenter = MockImagesListPresenter()
        mockPresenter.view = mockView
        viewController.testablePresenter = mockPresenter
        
        // Загружаем view
        viewController.loadViewIfNeeded()
    }

    override func tearDown() {
        viewController = nil
        mockView = nil
        super.tearDown()
    }
    
    func testUpdateTableViewAnimated() {
        // Просто выводим в консоль
        print("testUpdateTableViewAnimated запускается")
    }
    
    func testShowErrorAlert() {
        // Просто выводим в консоль
        print("testShowErrorAlert запускается")
    }
    
    func testUpdateCellLikeStatus() {
        // Просто выводим в консоль
        print("testUpdateCellLikeStatus запускается")
    }
}





