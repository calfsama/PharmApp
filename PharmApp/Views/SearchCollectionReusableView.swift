//
//  SearchCollectionReusableView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 15/02/23.
//

import UIKit

class SearchCollectionReusableView: UICollectionReusableView {
    static let identifier = "SearchCollectionReusableView"
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Результаты"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var ratingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1).cgColor
        button.setTitle("Популярное", for: .normal)
        button.setTitleColor(UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func configure() {
        addSubview(ratingButton)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            
            ratingButton.topAnchor.constraint(equalTo: topAnchor),
            ratingButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingButton.widthAnchor.constraint(equalToConstant: 120),
            ratingButton.heightAnchor.constraint(equalToConstant: 35),
            
            label.topAnchor.constraint(equalTo: ratingButton.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
    }
}
