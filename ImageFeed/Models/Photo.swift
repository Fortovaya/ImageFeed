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
    let createdAt: String?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}
