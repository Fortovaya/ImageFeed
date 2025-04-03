//
//  ViewController.swift
//  ImageFeed
//
//  Created by Алина on 26.01.2025.
//

import UIKit

final class ImagesListViewController: UIViewController, ImagesListCellDelegate {
    
    //MARK: - Private variables
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let currentDate = Date()
    private let imagesListService: ImagesListServiceProtocol = ImagesListService.shared
    private var imageListServiceObserver: Any?
    
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.showsVerticalScrollIndicator = false
        tableView.isOpaque = true
        tableView.clearsContextBeforeDrawing = true
        tableView.clipsToBounds = true
        tableView.separatorStyle = .none
        tableView.separatorInset = .zero
        tableView.isEditing = false
        tableView.allowsSelection = true
        tableView.backgroundColor = .ypLightBlack
        
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: ImagesListCell.reuseIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.contentMode = .scaleToFill
        view.backgroundColor = .ypLightBlack
        setupTableView()
        
        imageListObserver()
        imagesListService.fetchPhotosNextPage { result in
            switch result {
            case .success:
                self.updateTableViewAnimated()
            case .failure(let error):
                print("❌ Ошибка при загрузке фотографий: \(error)")
            }
        }
    }
    
    // MARK: - Override methods
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private methods
    private func setupTableView(){
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
    }
    
    func updateCellHeight(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
//        photos = imagesListService.photos
        
        let newPhotos = imagesListService.photos.suffix(newCount - oldCount)
        photos.append(contentsOf: newPhotos)
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in }
        }
    }
    
    private func imageListObserver(){
        imageListServiceObserver = NotificationCenter.default.addObserver(forName: ImagesListService.didChangeNotification, object: nil, queue: .main){ [weak self] _ in
            guard let self = self else{ return }
            self.updateTableViewAnimated()
        }
    }
}

//MARK: - Extension
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard indexPath.row < imagesListService.photos.count else {
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        let photo = photos[indexPath.row]

        guard let thumbImageURL = URL(string: photo.thumbImageURL) else { return cell }
        
        cell.setImage(from: thumbImageURL)
        cell.delegate = self
        configCell(for: cell, with: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // TO DO: sprint_12
        if indexPath.row == photos.count - 1 {
            imagesListService.fetchPhotosNextPage { result in
                switch result {
                case .success(_):
                    self.updateTableViewAnimated()
                case .failure(let error):
                    print("❌ Ошибка при загрузке следующих фотографий: \(error)")
                }
            }
        }
    }
}

extension ImagesListViewController {
    private func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard indexPath.row < photos.count else {
            print("❌ Ошибка: indexPath.row (\(indexPath.row)) выходит за границы массива photos.count (\(photos.count))")
            return
        }
        let photo = photos[indexPath.row]
        
        guard let url = URL(string: photo.thumbImageURL) else {
            print("❌ Ошибка: неверный URL - \(photo.thumbImageURL)")
            return
        }
            
        let isLiked = photo.isLiked
        let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
        let dateText: String
        if let dateString = photo.createdAt, let date = dateFormatter.date(from: dateString) {
            dateText = dateFormatter.string(from: date)
        } else {
            dateText = ""
        }
        cell.setImage(from: url)
        cell.configureCellWithImage(likeButtonImage: likeImage, date: dateText)
    }
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        print("Нажата кнопка лайк в ячейке \(cell)")
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        var photo = photos[indexPath.row]
        
        let newLikeState = !photo.isLiked
//        photo.isLiked = newLikeState
        photos[indexPath.row].isLiked = newLikeState
        
        imagesListService.updateLikeImage(isLiked: newLikeState, likeButton: cell.likeButtonForAction)
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: newLikeState) { result in
            switch result {
            case .success:
                print("Лайк успешно обновлен")
//                self.photos[indexPath.row].isLiked = newLikeState
                
                self.photos = self.imagesListService.photos
//                cell.setIsLiked(self.photos[indexPath.row].isLiked)
                self.imagesListService.updateLikeImage(isLiked: self.photos[indexPath.row].isLiked, likeButton: cell.likeButtonForAction)
                UIBlockingProgressHUD.dismiss()
                
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print("Ошибка при обновлении лайка: \(error)")
                self.photos[indexPath.row].isLiked = !newLikeState
                
            }
//            self.imagesListService.updateLikeImage(isLiked: newLikeState, likeButton: cell.likeButtonForAction)
        }
    }
    
    
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        updateCellHeight(at: indexPath)
        
        let singleImageVC = SingleImageViewController()
        singleImageVC.image = UIImage(named: photosName[indexPath.row])
        singleImageVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(singleImageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard indexPath.row < photos.count else {
            return 0
        }
        let photo = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / photo.size.width
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        
        return cellHeight
    }
}
