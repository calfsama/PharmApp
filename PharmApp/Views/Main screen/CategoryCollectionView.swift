//
//  CategoryCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 01/09/22.
//

import UIKit

class CategoryCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    var navigationController: UINavigationController
    var categories = [Categories]()

    init(nav: UIViewController) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.navigationController = nav as! UINavigationController
        super.init(frame: .zero, collectionViewLayout: layout)
        register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        delegate = self
        dataSource = self
        translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = 20
        contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        showsHorizontalScrollIndicator = false
        backgroundColor = .white
    }
    
    func set(cells: [Categories]) {
        self.categories = cells
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CategoryCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as! CategoryCollectionViewCell
        cell.title.text = categories[indexPath.row].title
        cell.image.image = categories[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let vc = MedicinesViewController()
            vc.title = categories[indexPath.row].title
            vc.id = "11"
            self.navigationController.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 1 {
            let vc = MainCategoriesViewController()
            vc.title = categories[indexPath.row].title
            vc.id = "178"
            self.navigationController.pushViewController(vc, animated: true)
        }
        else if indexPath.row == 2 {
            let vc = MedicinesViewController()
            vc.title = categories[indexPath.row].title
            vc.id = "9"
            self.navigationController.pushViewController(vc, animated: true)
        }
    } 
}
