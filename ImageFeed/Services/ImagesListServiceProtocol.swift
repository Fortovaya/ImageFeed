//
//  ImagesListServiceProtocol.swift
//  ImageFeed
//
//  Created by Алина on 29.03.2025.
//

protocol ImagesListServiceProtocol {
    
    func fetchPhotosNextPage(completion: ((Result<[Photo], Error>) -> Void)?)
    
    
}
