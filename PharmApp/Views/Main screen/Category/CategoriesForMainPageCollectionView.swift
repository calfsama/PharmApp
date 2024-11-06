//
//  CategoriesForMainPageCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 24/10/22.
//

import UIKit
import Kingfisher
import PocketSVG

class CategoriesForMainPageCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    var navigationController: UINavigationController
    var category: Category?
    
    var condition: Bool = false
    var isExpanded = [Bool]()
    var arr = [String]()
    
    init(nav: UIViewController) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.navigationController = nav as! UINavigationController
        super.init(frame: .zero, collectionViewLayout: layout)
        register(CategoriesForMainPageCollectionViewCell.self, forCellWithReuseIdentifier: CategoriesForMainPageCollectionViewCell.identifier)
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        isExpanded = Array(repeating: false, count: category?.categories?.count ?? 0)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
