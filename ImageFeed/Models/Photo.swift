//
//  Photo.swift
//  ImageFeed
//
//  Created by Алина on 28.03.2025.
//

import Foundation

struct Photo: Codable {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
    
    enum CodingKeys: String, CodingKey {
        case id
        case size
        case createdAt = "created_at"
        case welcomeDescription
        case thumbImageURL
        case largeImageURL
        case isLiked
    }
}
