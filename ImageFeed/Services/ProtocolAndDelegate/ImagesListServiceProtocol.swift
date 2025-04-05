//
//  ImagesListServiceProtocol.swift
//  ImageFeed
//
//  Created by Алина on 29.03.2025.
//

import UIKit

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    func fetchPhotosNextPage(completion: ((Result<[Photo], Error>) -> Void)?)
//    func updateLikeImage(isLiked: Bool, likeButton: UIButton)
    func changeLike(photoId: String, isLike: Bool, _ completion: @escaping (Result<Void, NetworkError>) -> Void)
}
