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
                switch result {
                case .success(let data):
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                           let token = json["access_token"] as? String {
                            completion(.success(token))
                        } else {
                            completion(.failure(NSError(domain: "InvalidData", code: 0, userInfo: nil)))
                        }
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            task.resume()
        case .failure(let error):
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


