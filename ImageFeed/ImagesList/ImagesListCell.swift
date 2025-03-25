//
//  ImagesListCellTableViewCell.swift
//  ImageFeed
//
//  Created by Алина on 26.01.2025.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    // MARK: - Private properties
    let cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        return likeButton
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gradientLayer = CAGradientLayer()
    
    private let gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Static properties
    static let reuseIdentifier = "ImagesListCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradientFrame()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private methods
    private func setupCell(){
        contentView.clipsToBounds = true 
        contentView.addSubview(cellImage)
        contentView.addSubview(likeButton)
        contentView.addSubview(dateLabel)
        
        NSLayoutConstraint.activate([
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            
            likeButton.heightAnchor.constraint(equalToConstant: 44),
            likeButton.widthAnchor.constraint(equalToConstant: 44),
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor, constant: 8),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor, constant: -8),
                        
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: cellImage.trailingAnchor, constant: -8)
            
        ])
        
        contentView.backgroundColor = .ypLightBlack
        addGradientBackground()
    }
    
    private func addGradientBackground() {
        gradientLayer.colors = [
            UIColor.ypWhite.withAlphaComponent(0.2).cgColor,
            UIColor.ypDarkGray.withAlphaComponent(0.4).cgColor
        ]
        
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.cornerRadius = 6
        
        dateLabel.layer.insertSublayer(gradientLayer, at: 0)
        updateGradientFrame()
    }
    
    private func updateGradientFrame() {
        gradientLayer.frame = dateLabel.bounds.insetBy(dx: -4, dy: -1)
        
        let borderLayer = CAShapeLayer()
        borderLayer.path = UIBezierPath(roundedRect: gradientLayer.bounds, cornerRadius: 6).cgPath
        borderLayer.lineWidth = 0.9
        borderLayer.strokeColor = UIColor.ypWhite.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor

        gradientLayer.sublayers?.removeAll(where: { $0 is CAShapeLayer })
        gradientLayer.addSublayer(borderLayer)
    }
}
