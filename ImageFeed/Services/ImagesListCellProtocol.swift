//
//  ImagesListCellProtocol.swift
//  ImageFeed
//
//  Created by Алина on 30.03.2025.
//

import UIKit

protocol ImagesListCellProtocol: AnyObject {
    
    func configureCellWithImage(image: UIImage?, likeButtonImage: UIImage?, date: String)
    func setImage(from url: URL)
    
}
