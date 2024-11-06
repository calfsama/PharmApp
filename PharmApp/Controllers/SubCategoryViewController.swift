//
//  SubCategoryViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 21/11/22.
//

import UIKit

class SubCategoryViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    var categoriesCollectionView: CategoriesForMainPageTwoCollectionView!
    var network = NetworkService()
    var category: CategoriesProducts?
    var subCat: [SubCategory]?
    var id = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        categoriesCollectionView = CategoriesForMainPageTwoCollectionView(nav: self.navigationController!)
        categoriesCollectionView.delegate = self
        categoriesCollectionView.dataSource = self
        fetchData()
        configureConstraints()
    }
    
    func configureConstraints() {
        view.addSubview(categoriesCollectionView)
        
        NSLayoutConstraint.activate([
            categoriesCollectionView.heightAnchor.constraint(equalToConstant: view.frame.size.height),
            categoriesCollectionView.widthAnchor.constraint(equalToConstant: view.frame.size.width)
        ])
    }
    
    func fetchData(){
        let urlString = "/categories/products/\(id)?page=1"
        self.network.mainCategories(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.category = response
                self.categoriesCollectionView.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }}
extension SubCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCat?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = categoriesCollectionView.dequeueReusableCell(withReuseIdentifier: CategoriesForMainPageCollectionViewCell.identifier, for: indexPath) as! CategoriesForMainPageCollectionViewCell
        cell.configure()
        cell.button.setImage(UIImage(named: "arrow"), for: .normal)
        cell.category.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        cell.category.text = subCat?[indexPath.row].category_name ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = MainCategoriesViewController()
        vc.title = subCat?[indexPath.row].category_name ?? ""
        vc.id = subCat?[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
