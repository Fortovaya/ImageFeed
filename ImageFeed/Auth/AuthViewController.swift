//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Алина on 16.02.2025.
//

import UIKit

class AuthViewController: UIViewController {
    
    // MARK: - Private lazy properties
    private lazy var logoOfUnsplashImageView: UIImageView = {
        let logoOfUnsplashImageView = UIImageView(image: UIImage(named: "auth_screen_logo"))
        logoOfUnsplashImageView.translatesAutoresizingMaskIntoConstraints = false
        return logoOfUnsplashImageView
    }()
    
    private lazy var activeButton: UIButton = {
        let activeButton = UIButton(type: .system)
        activeButton.backgroundColor = .ypWhite
        activeButton.layer.cornerRadius = 16
        activeButton.layer.masksToBounds = true
        
        activeButton.setTitle("Войти", for: .normal)
        activeButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        activeButton.setTitleColor(.ypLightBlack, for: .normal)
        activeButton.titleLabel?.textAlignment = .center
        
        activeButton.addTarget(self, action: #selector(didTapActiveButton), for: .touchUpInside)
    
        activeButton.translatesAutoresizingMaskIntoConstraints = false
        return activeButton
    }()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Private methods
    private func setupUI(){
        configureConstraintsLogoOfUnsplashImageView()
        configureActiveButton()
    }
    
    private func configureConstraintsLogoOfUnsplashImageView(){
        view.addSubview(logoOfUnsplashImageView)
        
        NSLayoutConstraint.activate([
            logoOfUnsplashImageView.heightAnchor.constraint(equalToConstant: 60),
            logoOfUnsplashImageView.widthAnchor.constraint(equalToConstant: 60),
            logoOfUnsplashImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 236),
            logoOfUnsplashImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 157)
        ])
    }
    
    private func configureActiveButton(){
        view.addSubview(activeButton)
        
        NSLayoutConstraint.activate([
            activeButton.heightAnchor.constraint(equalToConstant: 48),
            activeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            activeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            activeButton.topAnchor.constraint(equalTo: logoOfUnsplashImageView.bottomAnchor, constant: 300)
        ])
    }
    
    //MARK: - Action
    @objc private func didTapActiveButton(){
        
    }
}
