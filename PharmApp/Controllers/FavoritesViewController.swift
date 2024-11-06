//
//  FavoritesViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 01/09/22.
//

import UIKit
import CoreData
import KeychainAccess

class FavoritesViewController: UIViewController {
    var network = NetworkService()
    var favoriteCollectionView: FavoriteCollectionView!
    var collection = GoodsCollectionView()
    let keychain = Keychain(service: "tj.info.Salomat")
    var spinner = UIActivityIndicatorView()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "favsIcon")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var empty: UILabel = {
        let label = UILabel()
        label.text = "Кажется, здесь пусто"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var message: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.text = "для добавления товаров\n воспользуйтесь каталогом"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Избранное"
        view.backgroundColor = .white
        favoriteCollectionView = FavoriteCollectionView(nav: self.navigationController!)
        spinner.color = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        spinner.center = view.center
        view.addSubview(spinner)
        spinner.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favorites()
    }
    
    func configure() {
        view.addSubview(empty)
        view.addSubview(image)
        view.addSubview(message)
        
        NSLayoutConstraint.activate([
//            empty.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            empty.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            empty.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            empty.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            image.bottomAnchor.constraint(equalTo: empty.topAnchor, constant: -10),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            message.topAnchor.constraint(equalTo: empty.bottomAnchor, constant: 10),
            message.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            message.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func configureConstraints() {
        view.addSubview(favoriteCollectionView)
        
        NSLayoutConstraint.activate([
            favoriteCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            favoriteCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoriteCollectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    func favorites(){
        let urlString = "/favorites?user_id=\(keychain["UserID"] ?? "")"
        self.network.favorites(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.favoriteCollectionView.favorites = response
                self.favoriteCollectionView.reloadData()
                self.spinner.stopAnimating()
                if response.count != 0 {
                    self.configureConstraints()
                    self.favoriteCollectionView.reloadData()
                }
                else if response.count == 0 {
                    self.configure()
                    self.favoriteCollectionView.reloadData()
                }
            case .failure(let error):
                print("error", error)
                self.configure()
                self.spinner.stopAnimating()
                self.favoriteCollectionView.removeFromSuperview()
            }
        }
    }
}
