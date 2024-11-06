//
//  CategoriesForMainPageCollectionViewCell.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 24/10/22.
//

import UIKit

class CategoriesForMainPageCollectionViewCell: UICollectionViewCell {
    static let identifier = "CategoriesForMainPageCollectionViewCell"
    
    lazy var icon: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var category: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
   
    
    func configureConstraints() {
        contentView.addSubview(icon)
        contentView.addSubview(category)
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            icon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            icon.heightAnchor.constraint(equalToConstant: 20),
            icon.widthAnchor.constraint(equalToConstant: 20),
            
            category.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            category.leadingAnchor.constraint(equalTo: icon.trailingAnchor, constant: 10),
            
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 20),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    func configure() {
        contentView.addSubview(category)
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            category.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            category.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 20),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
