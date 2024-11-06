//
//  BlogListCollectionViewCell.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 19/09/22.
//

import UIKit

class BlogListCollectionViewCell: UICollectionViewCell {
    static let identifier = "BlogListCollectionViewCell"
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        title.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        title.alpha = 0.9
        title.numberOfLines = 2
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var date: UILabel = {
        let date = UILabel()
        date.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        date.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        date.translatesAutoresizingMaskIntoConstraints = false
        return date
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
    }
    
    func configureConstraints() {
        contentView.addSubview(title)
        contentView.addSubview(date)
        contentView.addSubview(image)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            date.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            date.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            date.trailingAnchor.constraint(equalTo: image.leadingAnchor, constant: -15),
 
            image.widthAnchor.constraint(equalToConstant: 70),
            image.heightAnchor.constraint(equalToConstant: 70),

            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 16),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
