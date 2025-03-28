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
    
    //номер последней скачанной страницы
    private var lastLoadedPage: Int?
    private var isFetching = false
    private let oAuth2TokenStorage = OAuth2TokenStorage.storage
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    
    private func makePhotosNextPage(token: String) -> Result<URLRequest, OAuthTokenRequestError> {
        guard let url = Constants.defaultBaseURL?.appendingPathComponent("photos") else {
            print("Ошибка: Неверный URL PhotosNextPage")
            return.failure(.invalidBaseURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return.success(request)
    }
    
    // функция скачивания страницы
    private func fetchPhotosNextPage(){
//        let nextPage = (lastLoadedPage?.number ?? 0) + 1

    }
}
