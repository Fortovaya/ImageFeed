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
    
    func makePhotosNextPage(token: String) -> Result<URLRequest, OAuthTokenRequestError>{
        let nextPage = (lastLoadedPage ?? 0) + 1
        //        self.lastLoadedPage = nextPage
        guard let baseURL = Constants.defaultBaseURL else {
            print("Ошибка: baseURL отсутствует")
            return .failure(.invalidRequest)
        }
        
        let photosPath = baseURL.appendingPathComponent("photos")
        
        var urlComponents = URLComponents(url: photosPath, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = [URLQueryItem(name: "page", value: "\(nextPage)")]
        
        guard let url = urlComponents?.url else {
            print("Ошибка: Неверный URL PhotosNextPage")
            return .failure(.invalidRequest)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return .success(request)
    }
    
    // функция скачивания страницы
    func fetchPhotosNextPage(completion: ((Result<[Photo], Error>) -> Void)? = nil){
        assert(Thread.isMainThread)
        
        let nextPage = (lastLoadedPage ?? 0) + 1
        
        guard !isFetching else {
            print("Запрос уже выполняется")
            return
        }
        
        isFetching = true
        
        guard let token = oAuth2TokenStorage.token else {
            print("Ошибка: Токен отсутствует")
            isFetching = false
            return
        }
        
        print("Запрос на загрузку следующей страницы с токеном \(token)")
        
        switch makePhotosNextPage(token: token){
        case .failure(let error):
            print("Ошибка создания запроса makeProfileRequest: \(error)")
            isFetching = false
            completion?(.failure(error))
            
        case .success(let request):
            let task = urlSession.objectTask(for: request){ [weak self ] (result: Result<[PhotoResult], Error>) in
                guard let self = self else { return }
                self.isFetching = false
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let photoResult):
                        print("Загружено \(photoResult.count) фотографий")
                        let newPhotos = photoResult.map { Photo(from: $0) }
                        self.photos.append(contentsOf: newPhotos)
                        //                        self.lastLoadedPage = (self.lastLoadedPage ?? 0) + 1
                        self.lastLoadedPage = nextPage
                        
                        print("✅ Фотографии загружены, отправляем уведомление")
                        self.sentNotification()
                        
                        completion?(.success(newPhotos))
                        
                    case .failure(let error):
                        print("Ошибка при загрузке фотографий: \(error)")
                        completion?(.failure(error))
                    }
                }
            }
            self.task = task
            task.resume()
        }
    }
    
    func sentNotification() {
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
    }
}
