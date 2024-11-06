//
//  NotificationsViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 22/11/22.
//

import UIKit

class NotificationsViewController: UIViewController {
    var notificationCollectionView = NotificationCollectionView()
    var news = NotificationNewsCollectionView()
    var network = NetworkService()
    var notification: NotificationData?
    
    lazy var viewforNews: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()

    lazy var viewforPromotions: UIView = {
        let uiView = UIView()
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var notificationButton: UIButton = {
        var button = UIButton()
        button.setTitle("Уведомления", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(changeScroll2), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var uiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.235, green: 0.902, blue: 0.51, alpha: 1)
        uiView.layer.cornerRadius = 4
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var notificationScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.frame = view.bounds
        scroll.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height - 100)
        scroll.backgroundColor = .white
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()
    
    lazy var newsButton: UIButton = {
        var button = UIButton()
        button.setTitle("Новости", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(changeScroll), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var newsScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.frame = view.bounds
        scroll.contentSize = CGSize(width: view.frame.size.width, height: 1000)
        scroll.backgroundColor = .white
        scroll.showsVerticalScrollIndicator = true
        return scroll
    }()
    
    lazy var header: UIView = {
        let header = UIView()
        header.backgroundColor = .white
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        fetchNotifications()
        configure()
    }
    
    func configure() {
        view.addSubview(viewforNews)
        view.addSubview(notificationButton)
        view.addSubview(newsButton)
        view.addSubview(uiView)
        viewforNews.addSubview(notificationCollectionView)
        newsButton.setTitleColor(UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1), for: .normal)
        notificationButton.setTitleColor(UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1), for: .normal)
        
        NSLayoutConstraint.activate([
            viewforNews.topAnchor.constraint(equalTo: notificationButton.bottomAnchor, constant: 20),
            viewforNews.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            viewforNews.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            
            notificationButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            notificationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            notificationButton.heightAnchor.constraint(equalToConstant: 20),
            notificationButton.widthAnchor.constraint(equalToConstant: 130),
            
            newsButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor,constant: 20),
            newsButton.leadingAnchor.constraint(equalTo: notificationButton.trailingAnchor, constant: 5),
            newsButton.widthAnchor.constraint(equalToConstant: 100),
            newsButton.heightAnchor.constraint(equalToConstant: 20),
            
            uiView.topAnchor.constraint(equalTo: notificationButton.bottomAnchor, constant: 10),
            uiView.leadingAnchor.constraint(equalTo: notificationButton.leadingAnchor),
            uiView.heightAnchor.constraint(equalToConstant: 3),
            uiView.widthAnchor.constraint(equalToConstant: 130),
            
            notificationCollectionView.topAnchor.constraint(equalTo: viewforNews.topAnchor),
            notificationCollectionView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            notificationCollectionView.bottomAnchor.constraint(equalTo: viewforNews.bottomAnchor),
        ])
    }
    
    func fetchNotifications(){
        let urlString = "/PushNotification"
        let host = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.network.notif(urlString: host) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                //self.notificationCollectionView.notification = response
                self.notification = response
                var dataPromotions = self.notification?.filter { word in
                    return word.type == "promotions"
                }
                print(dataPromotions ?? 0, "notification type")
                self.notificationCollectionView.notification = dataPromotions
                var dataEvent = self.notification?.filter { word in
                    return word.type == "events" || word.type == "holidays"
                }
                self.news.notification = dataEvent
                print(result)
                self.notificationCollectionView.reloadData()
                self.news.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    func congifureScroll() {
        viewforNews.removeFromSuperview()
        uiView.removeFromSuperview()
        view.addSubview(viewforPromotions)
        viewforPromotions.comingFromRight2(containerView: viewforPromotions.superview!)
        viewforPromotions.addSubview(news)
        view.addSubview(uiView)
        newsButton.setTitleColor(UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1), for: .normal)
        notificationButton.setTitleColor(UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1), for: .normal)
        
        NSLayoutConstraint.activate([
            viewforPromotions.topAnchor.constraint(equalTo: notificationButton.bottomAnchor, constant: 20),
            viewforPromotions.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            viewforPromotions.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
    
            uiView.topAnchor.constraint(equalTo: newsButton.bottomAnchor, constant: 10),
            uiView.leadingAnchor.constraint(equalTo: newsButton.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: newsButton.trailingAnchor),
            uiView.heightAnchor.constraint(equalToConstant: 3),
            
            news.topAnchor.constraint(equalTo: viewforPromotions.topAnchor),
            news.leadingAnchor.constraint(equalTo: viewforPromotions.leadingAnchor),
            news.trailingAnchor.constraint(equalTo: viewforPromotions.trailingAnchor),
            news.bottomAnchor.constraint(equalTo: viewforPromotions.bottomAnchor)
        ])
    }
    
    @objc func changeScroll() {
        congifureScroll()
    }
    
    @objc func changeScroll2() {
        viewforPromotions.removeFromSuperview()
        uiView.removeFromSuperview()
        configure()
        viewforNews.comingFromRight3(containerView: viewforNews.superview!)
    }
    // upload image in API
}
//extension UIView {
//
//}
