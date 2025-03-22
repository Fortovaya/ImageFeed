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
            print("Ошибка: Неверный URL ProfileRequest")
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
        case .failure(let error):
            print("Ошибка создания запроса makeProfileRequest: \(error)")
            isFetching = false
        case .success(let request):
            let task = urlSession.objectTask(for: request){ [weak self] (result: Result<ProfileResult, Error>) in
                guard let self = self else { return }
                self.isFetching = false // Сбрасываем флаг после завершения запроса
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let profileResult):
                        let profile = Profile(from: profileResult)
                        self.profile = profile
                        completion(.success(profile))
                        
                        print("Профиль загружен, запрашиваем аватар...")
                        ProfileImageService.shared.fetchProfileImageURL(username: profile.userName) { result in
                            switch result {
                            case .success(let avatarURL):
                                print("Аватар успешно загружен: \(avatarURL)")
                            case .failure(let error):
                                print("Ошибка загрузки аватара: \(error)")
                            }
                        }
                        
                    case .failure(let error):
                        print("Ошибка сети makeProfileRequest: \(error.localizedDescription)")
                        completion(.failure(.urlRequestError(error)))
                    }
                }
            }
            self.task = task
            task.resume()
        }
    }
}
