//
//  CategoriesViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 06/10/22.
//

import UIKit
import Kingfisher

class CategoriesViewController: UIViewController {
    var category: Category?
    var medicine: MedicineFromCategory?
    var categoriesCollectionView: CategoriesCollectionView!
    var network = NetworkService()
    
    lazy var titleCategory: UILabel = {
        let label = UILabel()
        label.text = "Каталог товаров"
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        categoriesCollectionView = CategoriesCollectionView(nav: self.navigationController!)
        configureConstraints()
        categoriesCollectionView.register(CategoriesForMainPageCollectionViewCell.self, forCellWithReuseIdentifier: CategoriesForMainPageCollectionViewCell.identifier)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
    }
    
    func configureConstraints() {
        view.addSubview(titleCategory)
        view.addSubview(categoriesCollectionView)
        
        NSLayoutConstraint.activate([
            titleCategory.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            titleCategory.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            categoriesCollectionView.topAnchor.constraint(equalTo: titleCategory.bottomAnchor, constant: 10),
            categoriesCollectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            categoriesCollectionView.widthAnchor.constraint(equalToConstant: view.frame.size.width)
        ])
    }
}
extension CategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        category?.categories?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesForMainPageCollectionViewCell.identifier, for: indexPath) as! CategoriesForMainPageCollectionViewCell
        cell.configureConstraints()
        cell.button.setImage(UIImage(named: "arrow"), for: .normal)
        cell.category.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        cell.category.text = category?.categories?[indexPath.row].category_name ?? ""
        let url = "http://salomat.tj/img/icons/"
        let completeURL = url + (category?.categories?[indexPath.row].icon ?? "")
        
        let charSet = CharacterSet.init(charactersIn: "svg")
        if ((category?.categories?[indexPath.row].icon?.rangeOfCharacter(from: charSet)) != nil){
            let svgUrl = URL(string: completeURL)
            cell.icon.downloadedsvg(from: svgUrl!)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("error", category?.categories?[indexPath.section].id ?? "")
        self.dismiss(animated: true)
        medicine?.update(id: category?.categories?[indexPath.row].id ?? "", name: category?.categories?[indexPath.row].category_name ?? "", subCat: (category?.categories?[indexPath.row].sub_cat)!)
    }
}
