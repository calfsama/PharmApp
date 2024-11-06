//
//  CategoryCollectionViewCell.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 01/09/22.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    static var identifier = "CategoryCollectionViewCell"
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.frame = CGRect(x: 0, y: 0, width: 60, height: 60)
        image.layer.cornerRadius = 0
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        title.textAlignment = .center
        title.textColor = UIColor(red: 0.429, green: 0.429, blue: 0.429, alpha: 1)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
    
    func configureConstraints() {
        contentView.addSubview(image)
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            
            title.centerXAnchor.constraint(equalTo: image.centerXAnchor),
            title.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
