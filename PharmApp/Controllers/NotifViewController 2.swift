//
//  NotifViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 20/02/23.
//

import UIKit

class NotifViewController: UIViewController {
    var notification: NotificationData?
    var network = NetworkService()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var collectionLayout: UICollectionViewFlowLayout! {
        didSet {
            collectionLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.register(NotifCollectionViewCell.self, forCellWithReuseIdentifier: NotifCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
//        collectionView.collectionViewLayout =
        fetchNotifications()
    }
    
    func fetchNotifications(){
        let urlString = "/PushNotification"
        let host = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.network.notif(urlString: host) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.notification = response
                print(result)
            case .failure(let error):
                print("error", error)
            }
        }
    }
}
extension NotifViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notification?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotifCollectionViewCell.identifier, for: indexPath) as! NotifCollectionViewCell
        
        cell.titleLabel.text = notification?[indexPath.item].title
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.maxWidth = collectionView.bounds.width - 16
        return cell
    }
}

