//
//  ReviewCollectionViewCell.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 24/11/22.
//

import UIKit
import Cosmos
import TinyConstraints

class ReviewCollectionViewCell: UICollectionViewCell {
    static let identifier = "ReviewCollectionViewCell"
    
    lazy var cosmosView: CosmosView = {
        let cosmos = CosmosView()
        cosmos.rating = 0.0
        cosmos.settings.fillMode = .precise
        cosmos.translatesAutoresizingMaskIntoConstraints = false
        return cosmos
    }()
    
    lazy var date: UILabel = {
        let label = UILabel()
        label.text = "25.11.2021"
        label.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var comment: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.text = "Хороший препарат, но упаковка неудобная"
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var author: UILabel = {
        let label = UILabel()
        label.text = "Автор: Фируз"
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
        contentView.layer.borderColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1).cgColor
        contentView.layer.borderWidth = 0.5
    }
    
    func configureConstraints() {
        contentView.addSubview(cosmosView)
        contentView.addSubview(date)
        contentView.addSubview(comment)
        contentView.addSubview(author)
        
        NSLayoutConstraint.activate([
            cosmosView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cosmosView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            
            date.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            date.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            comment.topAnchor.constraint(equalTo: date.bottomAnchor, constant: 20),
            comment.widthAnchor.constraint(equalToConstant: contentView.frame.size.width - 32),
            comment.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            comment.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            comment.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
            
            author.topAnchor.constraint(equalTo: comment.bottomAnchor, constant: 6),
            author.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
