//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Алина on 13.04.2025.
//

import UIKit

protocol ImagesListPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get }
    func viewDidLoad()
    func fetchPhotosNextPage()
    func changeLike(photoId: String, isLike: Bool)
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath)
    func calculateHeightForRow(at indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat
    func cellSelected(at indexPath: IndexPath)
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    
    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService: ImagesListServiceProtocol
    private var imageListServiceObserver: Any?
    
    var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    private lazy var serverDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()
    
    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared) {
        self.imagesListService = imagesListService
        setupObserver()
    }
    
    func viewDidLoad() {
        fetchPhotosNextPage()
    }
    
    func fetchPhotosNextPage() {
        imagesListService.fetchPhotosNextPage { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.updateTableViewAnimated()
            case .failure(let error):
                print("❌ Ошибка при загрузке фотографий: \(error)")
            }
        }
    }
    
    func changeLike(photoId: String, isLike: Bool) {
        assert(Thread.isMainThread)
        print("Нажата кнопка лайк для photoId: \(photoId)")
        
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photoId, isLike: isLike) { [weak self] result in
            guard let self = self else {
                UIBlockingProgressHUD.dismiss()
                return
            }
            
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                UIBlockingProgressHUD.dismiss()
                self.view?.updateCellLikeStatus(for: photoId)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                self.view?.showErrorAlert(with: "Ошибка",
                                          message: "Не удалось изменить лайк.")
                print("❌ Ошибка при изменении лайка: \(error.localizedDescription)")
            }
        }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard indexPath.row < photos.count else {
            print("❌ Ошибка: indexPath.row (\(indexPath.row)) выходит за границы массива photos.count (\(photos.count))")
            return
        }
        
        let photo = photos[indexPath.row]
        let url = photo.thumbImageURL
        
        if let dateString = photo.createdAt, let date = serverDateFormatter.date(from: dateString) {
            cell.dateLabel.text = dateFormatter.string(from: date)
            cell.dateLabel.isHidden = false
        } else {
            cell.dateLabel.isHidden = true
        }
        
        cell.cellImage.backgroundColor = .ypDarkGray
        cell.setImage(from: url)
        
        
        let isLiked = photo.isLiked
        let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
        cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    func calculateHeightForRow(at indexPath: IndexPath, tableViewWidth: CGFloat) -> CGFloat {
        guard indexPath.row < photos.count else { return 0 }
        let photo = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableViewWidth - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / photo.size.width
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
    
    private func setupObserver() {
        imageListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            self.updateTableViewAnimated()
        }
    }
    
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        
        if oldCount != newCount {
               let newPhotos = imagesListService.photos.suffix(newCount - oldCount)
               photos.append(contentsOf: newPhotos)
               
               DispatchQueue.main.async {
                   self.view?.updateTableViewAnimated(oldCount: oldCount, newCount: newCount)
               }
           }
    }
    
    deinit {
        if let observer = imageListServiceObserver {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    func cellSelected(at indexPath: IndexPath) {
        view?.updateCellHeight(at: indexPath)
    }
}
