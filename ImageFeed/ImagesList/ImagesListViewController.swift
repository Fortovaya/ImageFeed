//
//  ViewController.swift
//  ImageFeed
//
//  Created by Алина on 26.01.2025.
//

import UIKit

protocol ImagesListViewControllerProtocol: AnyObject {
    func updateTableViewAnimated(oldCount: Int, newCount: Int)
    func showErrorAlert(with title: String, message: String)
    func updateCellLikeStatus(for photoId: String)
//    func updateCellHeight(at indexPath: IndexPath)
}

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {
    
    //MARK: - Private variables
    private var presenter: ImagesListPresenterProtocol!
    
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
        presenter = ImagesListPresenter(imagesListService: ImagesListService.shared)
        presenter.view = self
        presenter.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
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
    
    func updateTableViewAnimated(oldCount: Int, newCount: Int) {
        DispatchQueue.main.async {
            if oldCount != newCount {
                self.tableView.performBatchUpdates {
                    let indexPaths = (oldCount..<newCount).map { i in
                        IndexPath(row: i, section: 0)
                    }
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                } completion: { _ in }
            }
        }
    }
    
    func showErrorAlert(with title: String, message: String) {
        let alertModel = AlertModel(
            title: title,
            message: message,
            buttonText: "OK",
            completion: nil,
            secondButtonText: nil,
            secondButtonCompletion: nil
        )
        AlertPresenter(viewController: self).showAlert(with: alertModel)
    }
    
    func updateCellLikeStatus(for photoId: String) {
        guard let visibleIndexPaths = tableView.indexPathsForVisibleRows else { return }
        
        for indexPath in visibleIndexPaths {
            guard
                indexPath.row < presenter.photos.count,
                presenter.photos[indexPath.row].id == photoId,
                let cell = tableView.cellForRow(at: indexPath) as? ImagesListCell
            else { continue }
            
            let isLiked = presenter.photos[indexPath.row].isLiked
            cell.setIsLiked(isLiked)
        }
    }
}

//MARK: - Extension
extension ImagesListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath) as? ImagesListCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        presenter.configCell(for: cell, with: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == presenter.photos.count - 1 {
            presenter.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let photo = presenter.photos[indexPath.row]
        
        let singleImageVC = SingleImageViewController()
        singleImageVC.image = photo
        singleImageVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(singleImageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.calculateHeightForRow(at: indexPath, tableViewWidth: tableView.bounds.width)
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        assert(Thread.isMainThread)
        print("Нажата кнопка лайк в ячейке \(cell)")
        
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = presenter.photos[indexPath.row]
        presenter.changeLike(photoId: photo.id, isLike: !photo.isLiked)
        
    }
}
