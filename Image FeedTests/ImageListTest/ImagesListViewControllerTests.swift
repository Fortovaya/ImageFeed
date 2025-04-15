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
        
        mockView = MockImagesListViewControllerProtocol()
        
        viewController = ImagesListViewController()
        
        let mockPresenter = MockImagesListPresenter()
        mockPresenter.view = mockView
        viewController.testablePresenter = mockPresenter
        
        viewController.loadViewIfNeeded()
    }
    
    override func tearDown() {
        viewController = nil
        mockView = nil
        super.tearDown()
    }
    
    func testUpdateTableViewAnimated() {
        print("testUpdateTableViewAnimated запускается")
    }
    
    func testShowErrorAlert() {
        print("testShowErrorAlert запускается")
    }
    
    func testUpdateCellLikeStatus() {
        print("testUpdateCellLikeStatus запускается")
    }
}





