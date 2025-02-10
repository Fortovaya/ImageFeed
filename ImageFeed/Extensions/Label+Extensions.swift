//
//  Label+Extensions.swift
//  ImageFeed
//
//  Created by Алина on 10.02.2025.
//
import UIKit

extension UILabel {
    func configure(_ block: (UILabel) -> Void) {
        block(self)
    }
}
