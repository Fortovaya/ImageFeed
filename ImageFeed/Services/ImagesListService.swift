//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Алина on 28.03.2025.
//

import UIKit

final class ImagesListService {
    
    //список скачанных фото
    private(set) var photos: [Photo] = []
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    //номер последней скачанной страницы
    private var lastLoadedPage: Int?
    private var isFetching = false
    private let oAuth2TokenStorage = OAuth2TokenStorage.storage
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    static let shared = ImagesListService()
    private init(){}
    
    private func makePhotosNextPage() -> URLRequest{
        let nextPage = (lastLoadedPage ?? 0) + 1
        self.lastLoadedPage = nextPage
        
        guard let url = Constants.defaultBaseURL?.appendingPathComponent("photos?page=\(nextPage)") else {
            print("Ошибка: Неверный URL PhotosNextPage")
            preconditionFailure("Невозможно сформировать URL запроса")
        }
        
        var request = URLRequest(url: url)
        
        guard let token = oAuth2TokenStorage.token else {
            print("Ошибка: Токен отсутствует")
            preconditionFailure("Токен отсутствует")
        }
        
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
    
    // функция скачивания страницы
    private func fetchPhotosNextPage(completion: @escaping (Result<String, NetworkError>)-> Void) {
        assert(Thread.isMainThread)
        
        let request = makePhotosNextPage()
        guard !isFetching else {
            print("Запрос уже выполняется")
            return
        }
        
        guard let token = oAuth2TokenStorage.token else {
            print("Ошибка: Токен отсутствует")
            completion(.failure(.missingToken))
            isFetching = false
            return
        }
        
        self.task = URLSession.shared.objectTask(for: request){ [weak self ] (result:Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let photoResult):
                photoResult.forEach{ photo in
                    let newPhoto = Photo(
                        id: photo.id,
                        size: CGSize(width: photo.width, height: photo.height),
                        createdAt: photo.createdAt,
                        welcomeDescription: photo.description,
                        thumbImageURL: photo.urls.thumb,
                        largeImageURL: photo.urls.full,
                        isLiked: photo.likedByUser
                    )
                    self.photos.append(newPhoto)
                }
                let nextPage = (lastLoadedPage ?? 0) + 1
                self.lastLoadedPage = nextPage
                
                NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                
            case .failure(let error):
                print("Error in ImageListService(fetchPhotosNextPage) : \(error)")
                completion(.failure(.requestFailed))
            }
            
            task = nil
        }
        self.task?.resume()
    }
}
