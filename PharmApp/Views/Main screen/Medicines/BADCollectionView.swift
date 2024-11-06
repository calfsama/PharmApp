//
//  BADCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 19/09/22.
//

import UIKit
import Kingfisher
import CoreData
import KeychainAccess

class BADCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    var navigationController: UINavigationController
    var vitamin: CategoriesForMainPage?
    var favorites: FavoritesData?
    var basket = [Basket]()
    var network = NetworkService()
    let keychain = Keychain(service: "tj.info.Salomat")
    var commitPredicate: NSPredicate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    init(nav: UIViewController) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.navigationController = nav as! UINavigationController
        super.init(frame: .zero, collectionViewLayout: layout)
        register(MedicinesCollectionViewCell.self, forCellWithReuseIdentifier: MedicinesCollectionViewCell.identifier)
        delegate = self
        dataSource = self
        layout.minimumLineSpacing = 16
        contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
    }
    
    func fetchFromApi(){
        let urlString = "/products/categories_for_main_page?user_id=\(keychain["UserID"] ?? "")"
        self.network.fetchFromApi(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.vitamin = response
                self.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension BADCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vitamin?.categories_for_main_page?[1].categ_prods?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: MedicinesCollectionViewCell.identifier, for: indexPath) as! MedicinesCollectionViewCell
        
        cell.title.text = vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].product_name ?? ""
        cell.price.text = (vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].product_price)! + " сом."
        let url = "http://salomat.tj/upload_product/"
        let completeURL = url + (vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].product_pic ?? "")
        switch vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].prod_rating_average {
        case .int(let intValue):
            cell.cosmosView.rating = Double(intValue)
        case .string(let stringValue):
            cell.cosmosView.rating = Double(stringValue) ?? 0
        default: break
            
        }
        cell.reloadData = self
        cell.image.kf.indicatorType = .activity
        cell.image.kf.setImage(with: URL(string: completeURL))
        if vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].is_favorite == false {
            cell.button.setImage(UIImage(named: "favorite"), for: .normal)
            cell.isFav = false
            }
        else if vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].is_favorite == true{
            cell.button.setImage(UIImage(named: "heart"), for: .normal)
            cell.isFav = true
            }
        cell.count = Int(vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].total_count_in_store ?? "") ?? 0
        cell.titleMedicine = vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].product_name ?? ""
        cell.prices = vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].product_price ?? ""
        cell.images = vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].product_pic ?? ""
        cell.is_favorite = ((vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].is_favorite) != nil)
        cell.id = vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].id ?? ""
//        if favorites?[indexPath.row].id == vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].id {
//            cell.button.setImage(UIImage(named: "heart"), for: .normal)
//        }
//        else {
//            cell.button.setImage(UIImage(named: "favorite"), for: .normal)
//        }
        cell.configureConstraints()
        let fetchRequest: NSFetchRequest <Basket> = Basket.fetchRequest()
        commitPredicate = NSPredicate(format: "id == %@", vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].id ?? "")
        fetchRequest.predicate = commitPredicate
        do {
            let data = try context.fetch(fetchRequest)
            for i in data {
                if i.id == self.vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].id ?? "" {
                    cell.cartButton.backgroundColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
                    cell.cartButton.setTitle("Убрать из корзины", for: .normal)
                    cell.contentView.layer.borderColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1).cgColor
                }
                else if i.id == nil{
                    cell.cartButton.backgroundColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1)
                    cell.contentView.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
                    cell.cartButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                    cell.cartButton.setTitle("В корзину", for: .normal)
                }
            }
        }
        catch {
            print("Error\(error)")
        }
        
        cell.hideSkeleton()
        cell.startSkeletonAnimation()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2.1 * 0.92, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AboutProductViewController()
        vc.id = vitamin?.categories_for_main_page?[1].categ_prods?[indexPath.row].id ?? ""
        self.navigationController.pushViewController(vc, animated: true)
    }
}
extension BADCollectionView: ReloadData {
    func update() {
        fetchFromApi()
//        self.reloadData()
    }
}
