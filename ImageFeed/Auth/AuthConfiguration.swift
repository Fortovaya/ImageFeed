//
//  Constants.swift
//  ImageFeed
//
//  Created by Алина on 15.02.2025.
//
import Foundation

enum Constants {
    static let accessKey: String = "wjMXyfVMnJpxxoQ6rnlRrohVvYFJZAe0k02KdwRh7iQ"
    static let secretKey: String = "pFcDZ-E1oi2FRYEqzq_73Z684QHIDEvhWtcvQYPJ6So"
    static let redirectURI: String = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope: String = "public+read_user+write_likes"
    static let defaultBaseURL: URL? = URL(string: "https://api.unsplash.com/")
}

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL?
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL?) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    // Статическая переменная для стандартной конфигурации
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: WebViewConstants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
    
    // Статическая переменная для тестовой конфигурации (можно будет использовать для тестирования)
    static var test: AuthConfiguration? {
        guard let baseURL = Constants.defaultBaseURL else { return nil }
        return AuthConfiguration(accessKey: Constants.accessKey,
                                 secretKey: Constants.secretKey,
                                 redirectURI: Constants.redirectURI,
                                 accessScope: Constants.accessScope,
                                 authURLString: WebViewConstants.unsplashAuthorizeURLString,
                                 defaultBaseURL: Constants.defaultBaseURL)
    }
}


/*
let authConfig = AuthConfiguration.standard
print(authConfig.accessKey)
*/
