//
//  SimilarProductsCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 28/12/22.
//

import UIKit
import Kingfisher

class SimilarProductsCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    var products: ProductsShow?
    var network = NetworkService()
    var id: String = ""
    var navigationController: UINavigationController
    
    init(nav: UIViewController) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.navigationController = nav as! UINavigationController
        super.init(frame: .zero, collectionViewLayout: layout)
        register(MedicinesCollectionViewCell.self, forCellWithReuseIdentifier: MedicinesCollectionViewCell.identifier)
        fetchBanner()
        delegate = self
        dataSource = self
        layout.minimumLineSpacing = 16
        contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        print(id, "similar")
        translatesAutoresizingMaskIntoConstraints = false
        showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SimilarProductsCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if products?.similar_products?.count == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            emptyLabel.text = "Список пуст"
            emptyLabel.textColor = .gray
            emptyLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
            emptyLabel.textAlignment = NSTextAlignment.center
            collectionView.backgroundView = emptyLabel
            //collectionView.separatorStyle = .none
            return 0
        }
        return products?.similar_products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: MedicinesCollectionViewCell.identifier, for: indexPath) as! MedicinesCollectionViewCell
        cell.id = products?.similar_products?[indexPath.row].id ?? ""
        //cell.is_favorite = ((products?.similar_products?[indexPath.row].is_favorite) != nil)
        cell.titleMedicine = products?.similar_products?[indexPath.row].product_name ?? ""
        cell.images = products?.similar_products?[indexPath.row].product_pic ?? ""
        cell.prices = products?.similar_products?[indexPath.row].product_price ?? ""
        cell.title.text = products?.similar_products?[indexPath.row].product_name ?? ""
        cell.count = Int(products?.similar_products?[indexPath.row].total_count_in_store ?? "") ?? 0
        let url = "http://salomat.tj/upload_product/"
        let completeURL = url + (products?.similar_products?[indexPath.row].product_pic ?? "qwerty.png")
        cell.image.kf.indicatorType = .activity
        cell.image.kf.setImage(with: URL(string: completeURL))
        cell.image.downloaded(from: completeURL)
//        if products?.similar_products?[indexPath.row].is_favorite == true {
//            cell.button.setImage(UIImage(named: "heart"), for: .normal)
//        }
//        else  {
//            cell.button.setImage(UIImage(named: "favorite"), for: .normal)
//        }
        cell.titleMedicine = products?.similar_products?[indexPath.row].product_name ?? ""
        cell.prices = products?.similar_products?[indexPath.row].product_price ?? ""
        cell.images = products?.similar_products?[indexPath.row].product_pic ?? ""
        cell.price.text = (products?.similar_products?[indexPath.row].product_price)! + " сом."
      //  cell.is_favorite = ((products?.similar_products?[indexPath.row].is_favorite) != nil)
        cell.id = products?.similar_products?[indexPath.row].id ?? ""
        cell.configureConstraints()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.1 * 0.92, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AboutProductViewController()
        vc.title = products?.similar_products?[indexPath.row].product_name ?? ""
        vc.id = products?.similar_products?[indexPath.row].id ?? ""
        self.navigationController.pushViewController(vc, animated: true)
//
    }
    
    func fetchBanner(){
        let urlString = "http://salomat.tj/products/show?product_id=\(id)"
        self.network.productShow(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.products = response
                print(result)
                print(self.id, "similar products")
                self.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }
}
