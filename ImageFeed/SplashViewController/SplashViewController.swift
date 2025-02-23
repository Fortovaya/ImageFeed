//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Алина on 22.02.2025.
//

import UIKit

final class SplashViewController: UIViewController {
    
    //MARK: Private lazy properties
    private lazy var splashImage: UIImageView = {
        let splashImage = UIImageView(image:UIImage(named: "Vector"))
        
        splashImage.translatesAutoresizingMaskIntoConstraints = false
        return splashImage
    }()
    
    //MARK: Private properties
    private let idAuthViewController = "showAuthVCID"
    private let idTabBarControllerScene = "TabBarViewController"
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypLightBlack
        configureConstraintsSplashImage()
    }
    
    // MARK: - Override methods
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.validateAuthorization()
        }
    }
    
    //MARK: - Private methods
    private func configureConstraintsSplashImage(){
        view.addSubview(splashImage)
        
        NSLayoutConstraint.activate([
            splashImage.widthAnchor.constraint(equalToConstant: 72),
            splashImage.heightAnchor.constraint(equalToConstant: 75),
            splashImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 228),
            splashImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
    private func validateAuthorization(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        if OAuth2TokenStorage.storage.token != nil {
            print("Токен прошел авторизацию")
            if let tabBarController = storyboard.instantiateViewController(withIdentifier: idTabBarControllerScene) as? UITabBarController{
                print("Переход на TabBarController")
                navigationController?.setViewControllers([tabBarController], animated: true)
            }
        } else {
            print("Токен отсутствует, переход на AuthNavigationController")
            if let authViewController = storyboard.instantiateViewController(withIdentifier: idAuthViewController) as? AuthViewController {
                print("Переход на AuthViewController")
                authViewController.delegate = self
                navigationController?.pushViewController(authViewController, animated: true)
            }
        }
        
        // Вывод текущих контроллеров в стеке навигации
        if let viewControllers = navigationController?.viewControllers {
            print("Текущие контроллеры в стеке: \(viewControllers)")
        } else {
            print("Нет доступных контроллеров в стеке")
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first else {
            assertionFailure("Invalid window configuration")
            return
        }
        
        let tabBarController = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(withIdentifier: idTabBarControllerScene)
        
        window.rootViewController = tabBarController
    }
    
}

extension SplashViewController: AuthViewControllerDelegate {
    func didAuthenticate(_ vc: AuthViewController) {
        switchToTabBarController()
    }
}

