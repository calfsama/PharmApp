//
//  BasketCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 10/10/22.
//

import UIKit
import CoreData

class CartCollectionView: UICollectionView {
    var data = [Basket]()
    var commitPredicate: NSPredicate?
    var cost: String = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        register(CartCollectionViewCell.self, forCellWithReuseIdentifier: CartCollectionViewCell.identifier)
        register(BasketFooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: BasketFooterCollectionReusableView.identifier)
        register(CartHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CartHeaderCollectionReusableView.identifier)
        layout.minimumLineSpacing = 0
        showsVerticalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

