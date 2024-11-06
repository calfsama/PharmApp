//
//  MedicinalProductsCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 16/09/22.
//

import UIKit
import Kingfisher
import CoreData
import SkeletonView
import KeychainAccess

protocol ReloadData: class {
    func update()
}

class MedicinalProductsCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    var navigationController: UINavigationController
    var favorites: FavoritesData?
    var categories: CategoriesForMainPage?
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
        translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = 16
        contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        showsHorizontalScrollIndicator = false
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension MedicinalProductsCollectionView: UICollectionViewDelegate, SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return MedicinesCollectionViewCell.identifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories?.categories_for_main_page?[0].categ_prods?.count ?? 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: MedicinesCollectionViewCell.identifier, for: indexPath) as! MedicinesCollectionViewCell
     
        cell.title.text = categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].product_name ?? ""
        cell.price.text = ((categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].product_price) ?? "") + " сом."
        let url = "http://salomat.tj/upload_product/"
        let completeURL = url + (categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].product_pic ?? "")
        cell.count = Int(categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].total_count_in_store ?? "") ?? 0
        cell.image.kf.indicatorType = .activity
        cell.image.kf.setImage(with: URL(string: completeURL))
        cell.configureConstraints()
        cell.reloadData = self
        if categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].is_favorite == false {
            cell.button.setImage(UIImage(named: "favorite"), for: .normal)
            cell.isFav = false
            }
        else if categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].is_favorite == true{
            cell.button.setImage(UIImage(named: "heart"), for: .normal)
            cell.isFav = true
            }
        switch categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].prod_rating_average {
        case .int(let intValue):
            cell.cosmosView.rating = Double(intValue)
        case .string(let stringValue):
            cell.cosmosView.rating = Double(stringValue) ?? 0
        default: break
        }
        
//        if favorites?.count != 0 {
//            for i in 0..<(favorites?.count ?? 0) {
//                if (categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].id ?? "") == (favorites?[i].id ?? "") {
////                    print(categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].id ?? "", favorites?[i].id ?? "" , "compare ids")
//                    cell.button.tintColor = .green
//                    cell.button.backgroundColor = .green
//
//
//                }
//                else {
//                    print("ERROR not compare ids", categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].id, favorites?[i].id ?? "")
////                    cell.button.tintColor = .clear
////                    cell.button.backgroundColor = .clear
//                }
//                print(categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].id ?? "", favorites?[i].id ?? "" , "compare ids")
//            }
//        }
//        else {
//            print("ERROR")
//        }
        cell.titleMedicine = categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].product_name ?? ""
        cell.prices = categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].product_price ?? ""
        cell.images = categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].product_pic ?? ""
        cell.is_favorite = ((categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].is_favorite) != nil)
       
        cell.id = categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].id ?? ""
        cell.compare()
        let fetchRequest: NSFetchRequest <Basket> = Basket.fetchRequest()
        commitPredicate = NSPredicate(format: "id == %@", categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].id ?? "")
        fetchRequest.predicate = commitPredicate
        do {
            let data = try context.fetch(fetchRequest)
            for i in data {
                if i.id == self.categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].id ?? "" {
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
        cell.hideAnimation()
//        if (categories?.categories_for_main_page?[0].categ_prods?.count ?? 0) > 0 {
//            
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                cell.hideAnimation()
//            }
//        }

      
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2.1 * 0.92, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AboutProductViewController()
        vc.title = categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].product_name ?? ""
        vc.id = categories?.categories_for_main_page?[0].categ_prods?[indexPath.row].id ?? ""
        self.navigationController.pushViewController(vc, animated: true)

    }
    
    func fetchData(){
        let urlString = "/products/categories_for_main_page?user_id=\(keychain["UserID"] ?? "")"
        self.network.fetchFromApi(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.categories = response
                self.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }
}
extension MedicinalProductsCollectionView: ReloadData {
    func update() {
        fetchData()
//        self.reloadData()
    }
}
