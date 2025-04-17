//
//  WebViewViewController.swift
//  ImageFeed
//
//  Created by Алина on 16.02.2025.
//
import UIKit
@preconcurrency import WebKit

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController, WKUIDelegate, WebViewViewControllerProtocol {
    
    //MARK: - Delegate
    weak var delegate: WebViewViewControllerDelegate?
    var presenter: WebViewPresenterProtocol? = WebViewPresenter(authHelper: AuthHelper())
    
    // MARK: - Private properties
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.backgroundColor = .ypWhite
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressTintColor = .ypLightBlack
        progressView.progress = 0.5
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private lazy var backAuthVCButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "navBackButton"), for: .normal)
        button.addTarget(self, action: #selector(didTapBackAuthVCButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Life cycle
    override func viewDidLoad(){
        super.viewDidLoad()
        presenter?.viewDidLoad()
        view.backgroundColor = .ypWhite
        configureWebView()
        configureProgressView()
        
        let backButton = UIBarButtonItem(customView: backAuthVCButton)
        navigationItem.leftBarButtonItem = backButton
        
        webView.navigationDelegate = self
    }
    
    // MARK: - Override methods
    override func observeValue( forKeyPath keyPath: String?, of object: Any?,change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            presenter?.didUpdateProgressValue(webView.estimatedProgress)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - Override properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    // MARK: - Private methods
    private func configureWebView(){
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
#if DEBUG
        webView.accessibilityIdentifier = "UnsplashWebView"
#endif
    }
    
    private func configureProgressView(){
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    
    func setProgressValue(_ newValue: Float) {
        progressView.progress = newValue
    }
    
    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
    }
    
    @objc private func didTapBackAuthVCButton(){
        delegate?.webViewViewControllerDidCancel(self)
    }
}

//MARK: - Extension
extension WebViewViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        if let url = navigationAction.request.url {
            return presenter?.code(from: url)
        } else {
            return nil
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        progressView.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        progressView.isHidden = false
    }
}
