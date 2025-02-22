//
//  OAuth2Service.swift
//  ImageFeed
//
//  Created by Алина on 20.02.2025.
//
import Foundation

enum OAuthTokenRequestError: Error {
    case invalidBaseURL
    case invalidURL
}

enum NetworkError: Error {
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidResponseData
}

final class OAuth2Service {
    static let shared = OAuth2Service ()
    
    private init(){ }
    
    func makeOAuthTokenRequest(code: String) -> Result<URLRequest, OAuthTokenRequestError> {
        guard let baseURL = URL(string: "https://unsplash.com") else { return.failure(.invalidBaseURL) }
        guard let url = URL(
            string: "/oauth/token"
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            relativeTo: baseURL
        ) else { return.failure(.invalidURL)}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        return.success(request)
    }
    
    func fetchOAuthToken(code: String, completion: @escaping (Result<String, Error>) -> Void) {
        switch makeOAuthTokenRequest(code: code) {
        case .success(let request):
            let task = URLSession.shared.data(for: request) { [weak self] result in
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        do {
                            let decoder = JSONDecoder()
                            let response = try decoder.decode(OAuthTokenResponseBody.self, from: data)
                            OAuth2TokenStorage.shared.token = response.accessToken
                            completion(.success(response.accessToken))
                        }
                        catch {
                            print("Ошибка декодирования: \(error)")
                            completion(.failure(NetworkError.invalidResponseData))
                        }
                    case .failure(let error):
                        print("Ошибка сети: \(error)")
                        completion(.failure(error))
                    }
                }
            }
            task.resume()
        case.failure(let error):
            print("Ошибка создания запроса: \(error)")
            completion(.failure(error))
        }
    }
}

extension URLSession {
    func data(for request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) -> URLSessionTask {
        
        let fulfillCompletionOnTheMainThread: (Result<Data, Error>) -> Void = { result in  // 2
            DispatchQueue.main.async { completion(result) }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            if let data = data, let response = response, let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if 200 ..< 300 ~= statusCode {
                    fulfillCompletionOnTheMainThread(.success(data)) // 3
                } else {
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Ошибка: статус код \(statusCode), тело ответа: \(responseString)")
                    }
                    fulfillCompletionOnTheMainThread(.failure(NetworkError.httpStatusCode(statusCode))) // 4
                }
            } else if let error = error {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlRequestError(error))) // 5
            } else {
                fulfillCompletionOnTheMainThread(.failure(NetworkError.urlSessionError)) // 6
            }
        })
        
        return task
    }
}


