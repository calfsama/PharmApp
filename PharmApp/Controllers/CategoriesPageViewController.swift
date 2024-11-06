//
//  CategoriesForMainPageViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 24/10/22.
//

import UIKit

class CategoriesPageViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    var network = NetworkService()
    var collectionView: CategoriesForMainPageTwoCollectionView!
    var id: String = ""
    var arr: [String]?
    var subCat: [SubCat]?
    var openCategories: OpenCategories?
    var category: CategoriesProducts?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView = CategoriesForMainPageTwoCollectionView(nav: self.navigationController!)
        fetchData()
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back button"), style: .plain, target: self, action: #selector(goback))
        print(subCat, "subCat")
        configureConstraints()
    }
    
    @objc func goback() {
        navigationController?.popToRootViewController(animated: true)
        openCategories?.openCategories()
        print("went back")
    }
    
    func configureConstraints() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func fetchData(){
        let urlString = "/categories/products/\(id)?page=1"
        self.network.mainCategories(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.category = response
                self.collectionView.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }

}
extension CategoriesPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return subCat?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesForMainPageCollectionViewCell.identifier, for: indexPath) as! CategoriesForMainPageCollectionViewCell
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
        if subCat?[indexPath.row].sub_cat?.count == 0 {
            let vc = MainCategoriesViewController()
            vc.title = subCat?[indexPath.row].category_name ?? ""
            vc.id = subCat?[indexPath.row].id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            let vc = SubCategoryViewController()
            vc.id = subCat?[indexPath.row].id ?? ""
            //self.dismiss(animated: true)
            vc.subCat = (subCat?[indexPath.row].sub_cat)!
            vc.title = subCat?[indexPath.row].category_name ?? ""

            self.navigationController?.pushViewController(vc, animated: true)
        }
  
//        self.navigationController?.pushViewController(vc, animated: true)
    }
}
