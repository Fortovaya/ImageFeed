//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Алина on 09.03.2025.
//

import Foundation

struct UserResult: Codable {
    let profileImage: ProfileImage?
    
    enum CodingKeys: String, CodingKey {
        case profileImage = "profile_image"
    }
    
    struct ProfileImage: Codable {
        let small: String
        let medium: String
        let large: String
    }
}

final class ProfileImageService {
    //MARK: - Static variables
    static let shared = ProfileImageService()
    private init(){}
    
    //MARK: - Private variables
    private let oAuth2TokenStorage = OAuth2TokenStorage.storage
    private let urlSession = URLSession.shared
    private(set) var avatarURL: String?
    private var task: URLSessionTask?
    private var isFetching = false
    
    //MARK: - Private Method
    func makeProfileImageRequest(username: String, token: String) -> Result<URLRequest, OAuthTokenRequestError> {
        let urlString = "https://api.unsplash.com/users/\(username)"
        
        guard let url = URL(string: urlString) else {
            print("Ошибка: Неверный URL ProfileRequest")
            return.failure(.invalidBaseURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return .success(request)
    }
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, NetworkError>) -> Void) {
        guard !isFetching else {
            print("Запрос уже выполняется")
            return
        }
        
        isFetching = true // Устанавливаем флаг в true, чтобы блокировать другие запросы
        
        guard let token = oAuth2TokenStorage.token else {
            print("Ошибка: Токен отсутствует")
            completion(.failure(.missingToken))
            isFetching = false
            return
        }
        
        switch makeProfileImageRequest(username: username, token: token){
        case .failure(let error):
            print("Ошибка создания запроса makeProfileImageRequest: \(error)")
            completion(.failure(.urlRequestError(error)))
            isFetching = false
            
        case .success(let request):
            let task = urlSession.dataTask(with: request){ data, response, error in
                self.isFetching = false // Сбрасываем флаг после завершения запроса
                
                if let error = error {
                    print ("Ошибка:\(error.localizedDescription)")
                    completion(.failure(NetworkError.invalidResponseData))
                    return
                }
                
                guard let data = data else {
                    print("Ошибка: Нет данных в ответе makeProfileImageRequest")
                    completion(.failure(NetworkError.invalidResponseData))
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        let userResult = try decoder.decode(UserResult.self, from: data)
                        guard let smallImageUrl = userResult.profileImage?.small else {
                            completion(.failure(.invalidResponseData))
                            return
                        }
                        self.avatarURL = smallImageUrl
                        
                        completion(.success(smallImageUrl))
                    } catch {
                        print("Ошибка декодирования makeProfileImageRequest: \(error.localizedDescription)")
                        completion(.failure(NetworkError.urlRequestError(error)))
                    }
                }
            }
            self.task = task
            task.resume()
        }
    }
}


