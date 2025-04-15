//
//  MockImagesListPresenter.swift
//  ImageFeed
//
//  Created by Алина on 15.04.2025.
//
@testable import ImageFeed
import Foundation

class MockImagesListPresenter: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    
    var photos: [Photo] = []
    
    func viewDidLoad() {
        // Пустая реализация
    }
    
    func fetchPhotosNextPage() {
        // Пустая реализация
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        // Пустая реализация
    }
    
    func changeLike(photoId: String, isLike: Bool) {
        // Пустая реализация
    }
    
    func calculateHeightForRow(at indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
        return 100.0 // Возвращаем фиксированную высоту
    }
}
