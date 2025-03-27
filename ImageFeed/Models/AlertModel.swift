//
//  AlertModel.swift
//  ImageFeed
//
//  Created by Алина on 27.03.2025.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (() -> Void)?
}
