//
//  CatForMainPageViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 17/02/23.
//

import UIKit

class CatForMainPageViewController: UIViewController {
    var network = NetworkService()
    var id: String = ""
    var category: Category?
    var categoriesForMainPage: CategoriesForMainPageCollectionView!
    
    lazy var titlePage: UILabel = {
        let label = UILabel()
        label.text = "Каталог товаров"
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        fetchCategories()
        categoriesForMainPage = CategoriesForMainPageCollectionView(nav: self.navigationController!)
        configureConstraints()
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
    }
    
    func configureConstraints() {
        view.addSubview(titlePage)
        view.addSubview(categoriesForMainPage)
        
        NSLayoutConstraint.activate([
            titlePage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: -16),
            titlePage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            categoriesForMainPage.topAnchor.constraint(equalTo: titlePage.bottomAnchor, constant: 16),
            categoriesForMainPage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            categoriesForMainPage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            categoriesForMainPage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchCategories(){
        let urlString = "/products/categories"
        self.network.category(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.categoriesForMainPage.category = response
                self.categoriesForMainPage.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }
}
