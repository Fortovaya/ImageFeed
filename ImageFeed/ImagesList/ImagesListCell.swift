//
//  ImagesListCellTableViewCell.swift
//  ImageFeed
//
//  Created by Алина on 26.01.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    static let reuseIdentifier = "ImagesListCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    private func setupCell(){
        cellImage.layer.cornerRadius = 16
        cellImage.layer.masksToBounds = true
        
        dateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        dateLabel.textColor = UIColor(named: "#FFFFFF")
    }
}
