//
//  ImagesListCellTableViewCell.swift
//  ImageFeed
//
//  Created by Алина on 26.01.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - @IBOutlet properties
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    // MARK: - Static properties
    static let reuseIdentifier = "ImagesListCell"
    
    // MARK: - Override methods
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Private methods
    private func setupCell(){
        cellImage.layer.cornerRadius = 16
        cellImage.layer.masksToBounds = true
        
        dateLabel.backgroundColor = UIColor(named: "ypLightBlack")
        dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = UIColor(named: "#FFFFFF")
        addGradientBackground()
    }
    
    private func addGradientBackground() {
        let gradientLayer = CAGradientLayer()
        
        gradientLayer.colors = [
            UIColor.ypWhite.cgColor,
            UIColor.ypDarkGray.cgColor
        ]
        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.2, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.2, y: 1)
        
        gradientLayer.frame = dateLabel.bounds.insetBy(dx: -4, dy: -1)
        gradientLayer.cornerRadius = 6 // Закругляем углы
        
        dateLabel.layer.insertSublayer(gradientLayer, at: 0)
    }
}
