//
//  MedicinesCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 01/09/22.
//

import UIKit
import Kingfisher
import CoreData

class MedicinesCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    var navigationController: UINavigationController
    var cell = MedicinesCollectionViewCell()
    var sales: Sales?
    var basket = [Basket]()
    var commitPredicate: NSPredicate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    init(nav: UIViewController) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
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
extension MedicinesCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
        if sales?.total_products?.total_prods?.count == 0 {
            emptyLabel.text = "Пусто"
            emptyLabel.textColor = .gray
            emptyLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            emptyLabel.textAlignment = NSTextAlignment.center
            collectionView.backgroundView = emptyLabel
            return 0
        }
        else {
            emptyLabel.text = ""
            return sales?.total_products?.total_prods?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: MedicinesCollectionViewCell.identifier, for: indexPath) as! MedicinesCollectionViewCell
        cell.count = Int(sales?.total_products?.total_prods?[indexPath.row].total_count_in_store ?? "") ?? 0
        cell.id = sales?.total_products?.total_prods?[indexPath.row].id ?? ""
        cell.is_favorite = ((sales?.total_products?.total_prods?[indexPath.row].is_favorite) != nil)
        cell.titleMedicine = sales?.total_products?.total_prods?[indexPath.row].product_name ?? ""
        cell.prices = sales?.total_products?.total_prods?[indexPath.row].product_price ?? ""
        cell.images = sales?.total_products?.total_prods?[indexPath.row].product_pic ?? ""
        cell.title.text = sales?.total_products?.total_prods?[indexPath.row].product_name ?? ""
        cell.price.text = sales?.total_products?.total_prods?[indexPath.row].product_price ?? ""
        let url = "http://salomat.tj/upload_product/"
        let completeURL = url + (sales?.total_products?.total_prods?[indexPath.row].product_pic ?? "")
        cell.image.kf.indicatorType = .activity
        cell.image.kf.setImage(with: URL(string: completeURL))
        cell.configureConstraints()
        let fetchRequest: NSFetchRequest <Basket> = Basket.fetchRequest()
        if sales?.total_products?.total_prods?[indexPath.row].is_favorite == false {
            cell.button.setImage(UIImage(named: "favorite"), for: .normal)
            cell.is_favorite = false
            }
        else if sales?.total_products?.total_prods?[indexPath.row].is_favorite == true{
            cell.button.setImage(UIImage(named: "heart"), for: .normal)
            cell.is_favorite = true
            }
        commitPredicate = NSPredicate(format: "id == %@", sales?.total_products?.total_prods?[indexPath.row].id ?? "")
        switch sales?.total_products?.total_prods?[indexPath.row].prod_rating_average {
        case .int(let intValue):
            cell.cosmosView.rating = Double(intValue)
        case .string(let stringValue):
            cell.cosmosView.rating = Double(stringValue) ?? 0
        default: break
        }

        fetchRequest.predicate = commitPredicate
        do {
            let data = try context.fetch(fetchRequest)
            for i in data {
                if i.id == self.sales?.total_products?.total_prods?[indexPath.row].id ?? "" {
                    //print("\(i.title) and \(title)")
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
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2.3, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AboutProductViewController()
        vc.id = sales?.total_products?.total_prods?[indexPath.row].id ?? ""
        self.navigationController.pushViewController(vc, animated: true)
        
    }
}
