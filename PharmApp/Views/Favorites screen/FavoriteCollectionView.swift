//
//  FavoriteCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 17/10/22.
//

import UIKit
import Kingfisher

class FavoriteCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    var data = [DataModel]()
    var favorites: FavoritesData?
    var navigationController: UINavigationController
    var indicator: UIActivityIndicatorView = UIActivityIndicatorView()

    init(nav: UIViewController) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.navigationController = nav as! UINavigationController
        super.init(frame: .zero, collectionViewLayout: layout)
        register(MedicinesCollectionViewCell.self, forCellWithReuseIdentifier: MedicinesCollectionViewCell.identifier)
        indicator.frame = CGRect(x: 180, y: 280, width: 40, height: 40)
        indicator.color = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        indicator.startAnimating()
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        layout.minimumLineSpacing = 16
        contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension FavoriteCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let image = UIImageView(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
//        if favorites?.count == 0 {
//            image.image = UIImage(named: "fav")
//            collectionView.backgroundView = image
//            return 0
//        }
//        else {
//            image.image = UIImage(named: "")
//            collectionView.backgroundView = image
            return favorites?.count ?? 0
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: MedicinesCollectionViewCell.identifier, for: indexPath) as! MedicinesCollectionViewCell
        let url = "http://salomat.tj/upload_product/"
        let completeURL = url + (favorites?[indexPath.row].product_pic ?? "")
        cell.id = favorites?[indexPath.row].id ?? ""
        cell.is_favorite = ((favorites?[indexPath.row].is_favorite) != nil)
        cell.titleMedicine = favorites?[indexPath.row].product_name ?? ""
        cell.images = favorites?[indexPath.row].product_pic ?? ""
        cell.prices = favorites?[indexPath.row].product_price ?? ""
        cell.count = Int(favorites?[indexPath.row].total_count_in_store ?? "") ?? 0
        cell.image.kf.indicatorType = .activity
        cell.image.kf.setImage(with: URL(string: completeURL))
        cell.price.text = favorites?[indexPath.row].product_price ?? ""
        cell.title.text = favorites?[indexPath.row].product_name ?? ""
        switch favorites?[indexPath.row].prod_rating_average {
        case .int(let intValue):
            cell.cosmosView.rating = Double(intValue)
        case .string(let stringValue):
            cell.cosmosView.rating = Double(stringValue) ?? 0
        default: break
        }
        if favorites?[indexPath.row].is_favorite == false {
            cell.button.setImage(UIImage(named: "favorite"), for: .normal)
        }
        else {
            cell.button.setImage(UIImage(named: "heart"), for: .normal)
        }
        cell.configureConstraints()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2.3, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AboutProductViewController()
        vc.id = favorites?[indexPath.row].id ?? ""
        vc.title = favorites?[indexPath.row].product_name ?? ""
        navigationController.pushViewController(vc, animated: true)
    }
}
