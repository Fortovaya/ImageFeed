//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Алина on 01.02.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var loginNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var logoutButton: UIButton!
    
    var viewControllers: [UIViewController]?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUIProfile()
    }
    
    // MARK: - Private methods
    private func setupUIProfile(){
        
        self.view.backgroundColor = .ypLightBlack
        
        avatarImageView.frame.size = CGSize(width: 70, height: 70)
        
        nameLabel.frame.size = CGSize(width: 235, height: 18)
        nameLabel.font = UIFont(name: "SF Pro", size: 23)
        nameLabel.textColor = .ypWhite
        
        loginNameLabel.frame.size = CGSize(width: 99, height: 18)
        loginNameLabel.font = UIFont(name: "SF Pro", size: 13)
        loginNameLabel.textColor = .lightGray
        
        descriptionLabel.frame.size = CGSize(width: 77, height: 18)
        descriptionLabel.font = UIFont(name: "SF Pro", size: 13)
        descriptionLabel.textColor = .ypWhite
        
        logoutButton.setImage(UIImage(named: "Exit"), for: .normal)
        logoutButton.setTitle(nil, for: .normal)
        logoutButton.frame.size = CGSize(width: 44, height: 44)
    }
    
    @IBAction func didTapLogoutButton(_ sender: Any) {
        
    }
}
