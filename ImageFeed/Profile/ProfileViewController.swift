//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Алина on 01.02.2025.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // MARK: - Public properties
    private var avatarImageView: UIImageView?
    private var nameLabel: UILabel?
    private var loginNameLabel: UILabel?
    private var descriptionLabel: UILabel?
    private var logoutButton: UIButton?
    
    var viewControllers: [UIViewController]?
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAvatarImageView()
        configureNameLabel()
        configureLoginNameLabel()
        configureDescriptionLabel()
        configureLogoutButton()
    }
    
    // MARK: - Private methods
    private func configureAvatarImageView(){
        guard let avatarImage = UIImage(named: "Photo") else { return }
        let avatarImageView = UIImageView(image: avatarImage)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            avatarImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        ])
        self.avatarImageView = avatarImageView
    }
    
    private func configureNameLabel(){
        guard let avatarImageView = avatarImageView else { return }
        let nameLabel = UILabel()
        nameLabel.configure {
            $0.text = "Екатерина Новикова"
            $0.font = UIFont(name: "SFProDisplay-Regular", size: 23) ?? UIFont.systemFont(ofSize: 23)
            $0.textAlignment = .left
            $0.textColor = .ypWhite
        }
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        self.nameLabel = nameLabel
    }
    
    private func configureLoginNameLabel(){
        guard let nameLabel = nameLabel else { return }
        let loginNameLabel = UILabel()
        
        loginNameLabel.configure {
            $0.text = "@ekaterina_nov"
            $0.font = UIFont(name: "SFProDisplay-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)
            $0.textAlignment = .left
            $0.textColor = .ypLightGray
        }
        
        loginNameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loginNameLabel)
       
        NSLayoutConstraint.activate([
            loginNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            loginNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            loginNameLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        self.loginNameLabel = loginNameLabel
    }
    
    private func configureDescriptionLabel(){
        guard let loginNameLabel = loginNameLabel else { return }
        let descriptionLabel = UILabel()
        
        descriptionLabel.configure {
            $0.text = "Hello, world!"
            $0.font = UIFont(name: "SFProDisplay-Regular", size: 13) ?? UIFont.systemFont(ofSize: 13)
            $0.textAlignment = .left
            $0.textColor = .ypWhite
        }
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: loginNameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: loginNameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
        
        self.descriptionLabel = descriptionLabel
    }
    
    private func configureLogoutButton(){
        guard let avatarImageView = avatarImageView else { return }
        
        guard let exitImage = UIImage(named: "Exit") ?? UIImage(systemName: "ipad.and.arrow.forward") else { return }
        let logoutButton = UIButton.systemButton(with: exitImage, target: self, action: #selector(self.didTapLogoutButton))
        
        logoutButton.tintColor = .ypCoral
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoutButton)
        
        NSLayoutConstraint.activate([
            logoutButton.heightAnchor.constraint(equalToConstant: 44),
            logoutButton.widthAnchor.constraint(equalToConstant: 44),
            logoutButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            logoutButton.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor)
        ])
        self.logoutButton = logoutButton
    }
    
    //MARK: - Action
    @objc
    @IBAction func didTapLogoutButton() {
        
    }
}
