//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Алина on 22.02.2025.
//
import Foundation

final class OAuth2TokenStorage {
    private let tokenKey = "oauthToken"
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: tokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: tokenKey)
        }
    }
}
