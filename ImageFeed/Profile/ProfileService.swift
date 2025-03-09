//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Алина on 02.03.2025.
//

import Foundation

//MARK: - Struct
struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
    
    enum CodingKeys: String, CodingKey {
          case username
          case firstName = "first_name"
          case lastName = "last_name"
          case bio = "bio"
      }
}

struct Profile {
    let userName: String
    let firstName: String
    let lastName: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(from profileResult: ProfileResult) {
        self.userName = profileResult.username
        self.firstName = profileResult.firstName
        self.lastName = profileResult.lastName
        self.name = "\(profileResult.firstName) \(profileResult.lastName)"
        self.loginName = "@\(profileResult.username)"
        self.bio = profileResult.bio
    }
}

final class ProfileService {
    
    //MARK: - Private variables
    private let oAuth2TokenStorage = OAuth2TokenStorage.storage
    private let urlSession = URLSession.shared
    private var task: URLSessionTask?
    private var isFetching = false // для отслеживания выполнения процесса (гонки)
    
    static let shared = ProfileService()
    private init() {}
    
    private(set) var profile: Profile?
    
    //MARK: - Private Method
    func makeProfileRequest(token: String) -> Result<URLRequest, OAuthTokenRequestError> {
                
        guard let url = URL(string: "https://api.unsplash.com/me") else {
            print("Ошибка: Неверный URL")
            return.failure(.invalidBaseURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        return .success(request)
    }
    
    func fetchProfile(completion: @escaping (Result<Profile, NetworkError>) -> Void) -> Void {
        guard !isFetching else {
            print("Запрос уже выполняется")
            return
        }
        
        isFetching = true // Устанавливаем флаг в true, чтобы блокировать другие запросы
        
        guard let token = oAuth2TokenStorage.token else {
            print("Ошибка: Токен отсутствует")
            completion(.failure(NetworkError.missingToken))
            isFetching = false
            return
        }
        
        switch makeProfileRequest(token: token){
        case .failure(_):
            print("Ошибка создания запроса")
            isFetching = false
            return
        case .success(let request):
            let task = urlSession.dataTask(with: request){ data, response, error in
                self.isFetching = false // Сбрасываем флаг после завершения запроса
                
                if let error = error {
                    print ("Ошибка:\(error.localizedDescription)")
                    completion(.failure(NetworkError.invalidResponseData))
                    return
                }
                
                guard let data = data else {
                    print("Ошибка: Нет данных в ответе")
                    completion(.failure(NetworkError.invalidResponseData))
                    return
                }
                
                DispatchQueue.main.async {
                    do {
                        let decoder = JSONDecoder()
                        let profileResult = try decoder.decode(ProfileResult.self, from: data)
                        let profile = Profile(from: profileResult)
                        self.profile = profile
                        
                        completion(.success(profile))
                    } catch {
                        print("Ошибка декодирования: \(error.localizedDescription)")
                        completion(.failure(NetworkError.urlRequestError(error)))
                    }
                }
            }
            self.task = task
            task.resume()
        }
    }
}
