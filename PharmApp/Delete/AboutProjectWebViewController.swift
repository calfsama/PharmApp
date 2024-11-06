//
//  AboutProjectWebViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 19/01/23.
//

import UIKit
import WebKit

class AboutProjectWebViewController: UIViewController {
    let webView = WKWebView()
    var urlString: String = "http://salomat.tj/index.php/main/page/1"
    var spinner = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        indicator()
        configureConstraints()
        guard let url = URL(string: urlString) else { return }
        webView.load(URLRequest(url: url))
    }
    func indicator() {
        webView.addSubview(spinner)
        spinner.center = webView.center
        spinner.startAnimating()
        spinner.hidesWhenStopped = true
        webView.bringSubviewToFront(spinner)
        spinner.color = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
    }
    
    func configureConstraints() {
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
extension AboutProjectWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        indicator()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        spinner.stopAnimating()
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        spinner.stopAnimating()
    }
}

