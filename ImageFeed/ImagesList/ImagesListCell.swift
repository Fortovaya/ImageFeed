//
//  ImagesListCellTableViewCell.swift
//  ImageFeed
//
//  Created by Алина on 26.01.2025.
//

import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell, ImagesListCellProtocol {
    
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - Private properties
    private lazy var cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        return likeButton
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .ypWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Static properties
    static let reuseIdentifier = "ImagesListCell"
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
        cellImage.image = nil
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
    }
    
    func configureCellWithImage(image: UIImage?, likeButtonImage: UIImage?, date: String) {
        updateCellContent(image: image, likeButtonImage: likeButtonImage, date: date)
    }
    
    private func updateCellContent(image: UIImage?, likeButtonImage: UIImage?, date: String) {
        cellImage.image = image
        likeButton.setImage(likeButtonImage, for: .normal)
        dateLabel.text = date
    }
    
    func setImage(from url: URL) {
        cellImage.kf.cancelDownloadTask()
        loadImage(from: url)
    }
    
    private func loadImage(from url: URL) {
        let resource = KF.ImageResource(downloadURL: url, cacheKey: url.absoluteString)
        cellImage.kf.setImage(with: resource, placeholder: UIImage(named: "placeholder"))
//        options: [.transition(.fade(0.3))]) { result in
//            switch result {
//            case .success(let value):
//                print("Изображение успешно загружено из \(value.cacheType)")
//            case .failure(let error):
//                print("Ошибка загрузки изображения: \(error)")
//            }
//        }
                              
        cellImage.kf.indicatorType = .activity
    }
}

