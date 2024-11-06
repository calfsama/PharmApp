//
//  SubCategoryForMainPageCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 06/12/22.
//

import UIKit

class SubCategoryForMainPageCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    var category: Category?

    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        register(CategoriesForMainPageCollectionViewCell.self, forCellWithReuseIdentifier: CategoriesForMainPageCollectionViewCell.identifier)
        delegate = self
        dataSource = self
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SubCategoryForMainPageCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: CategoriesForMainPageCollectionViewCell.identifier, for: indexPath) as! CategoriesForMainPageCollectionViewCell
        cell.category.text = category?.categories?[indexPath.row].sub_cat?[indexPath.row].category_name ?? ""
        cell.button.setImage(UIImage(named: "arrow"), for: .normal)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 40)
    }
}
