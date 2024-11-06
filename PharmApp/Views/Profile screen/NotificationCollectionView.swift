//
//  NotificationCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 22/11/22.
//

import UIKit
import Kingfisher

class NotificationCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    var notification: NotificationData?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        super.init(frame: .zero, collectionViewLayout: layout)
        register(NotificationCollectionViewCell.self, forCellWithReuseIdentifier: NotificationCollectionViewCell.identifier)
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        contentInsetAdjustmentBehavior = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension NotificationCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if notification?.count == 0 {
            var emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            emptyLabel.text = "Уведомлений нет"
            emptyLabel.textColor = .gray
            emptyLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
            emptyLabel.textAlignment = NSTextAlignment.center
            collectionView.backgroundView = emptyLabel
            return 0
        }
        else {
            return notification?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: NotificationCollectionViewCell.identifier, for: indexPath) as! NotificationCollectionViewCell
        cell.contentView.layer.borderColor = UIColor(red: 0.963, green: 0.965, blue: 0.975, alpha: 1).cgColor
        cell.contentView.layer.borderWidth = 1
        cell.image.kf.indicatorType = .activity
        cell.image.kf.setImage(with: URL(string: notification?[indexPath.row].image ?? ""))
        cell.title.text = notification?[indexPath.row].title ?? ""
        cell.subtitle.text = notification?[indexPath.row].body ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 400)
    }
}

