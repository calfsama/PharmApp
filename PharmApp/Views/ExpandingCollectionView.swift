//
//  ExpandingCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 22/12/22.
//

import UIKit
import Kingfisher

class ExpandingCollectionView: UICollectionView {
    var condition: Bool = false
    var order: OrdersData?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        register(ExpandingCollectionViewCell.self, forCellWithReuseIdentifier: ExpandingCollectionViewCell.identifier)
        register(MyOrdersCollectionViewCell.self, forCellWithReuseIdentifier: MyOrdersCollectionViewCell.identifier)
        register(MyOrdersCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MyOrdersCollectionReusableView.identifier)
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
