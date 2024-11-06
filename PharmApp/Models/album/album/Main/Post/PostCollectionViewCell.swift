//
//  PostCollectionViewCell.swift
//  album
//
//  Created by Tomiris Negmatova on 01/11/22.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    static let identifier = "PostCollectionViewCell"
    var count: Int = 0
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var icon: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor(red: 0.548, green: 0.863, blue: 0.883, alpha: 1).cgColor
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var like: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var likeIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "heart.fill")
        image.tintColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var likeCount: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.text = "0"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var comment: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var commentIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "message.fill")
        image.tintColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var commentCount: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bookmark: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var bookmarkIcon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "bookmark.fill")
        image.tintColor = .black
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var bookmarkCount: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        configureConstraints()
    }
    
    func configureConstraints() {
        contentView.addSubview(image)
        contentView.addSubview(icon)
        contentView.addSubview(like)
        contentView.addSubview(comment)
        contentView.addSubview(bookmark)
        contentView.addSubview(likeIcon)
        contentView.addSubview(commentIcon)
        contentView.addSubview(bookmarkIcon)
        contentView.addSubview(likeCount)
        contentView.addSubview(commentCount)
        contentView.addSubview(bookmarkCount)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: contentView.topAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            image.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            image.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            icon.topAnchor.constraint(equalTo: image.topAnchor, constant: 10),
            icon.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 10),
            icon.heightAnchor.constraint(equalToConstant: 15),
            icon.widthAnchor.constraint(equalToConstant: 15),
            
            like.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -10),
            like.leadingAnchor.constraint(equalTo: image.leadingAnchor, constant: 8),
            like.heightAnchor.constraint(equalToConstant: 23),
            like.widthAnchor.constraint(equalToConstant: 65),
            
            likeIcon.centerYAnchor.constraint(equalTo: like.centerYAnchor),
            likeIcon.leadingAnchor.constraint(equalTo: like.leadingAnchor, constant: 5),
            likeIcon.heightAnchor.constraint(equalToConstant: 18),
            likeIcon.widthAnchor.constraint(equalToConstant: 18),
            
            comment.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -10),
            comment.leadingAnchor.constraint(equalTo: like.trailingAnchor, constant: 8),
            comment.heightAnchor.constraint(equalToConstant: 23),
            comment.widthAnchor.constraint(equalToConstant: 65),
            
            commentIcon.centerYAnchor.constraint(equalTo: comment.centerYAnchor),
            commentIcon.leadingAnchor.constraint(equalTo: comment.leadingAnchor, constant: 5),
            commentIcon.heightAnchor.constraint(equalToConstant: 17),
            commentIcon.widthAnchor.constraint(equalToConstant: 17),
            
            bookmark.bottomAnchor.constraint(equalTo: image.bottomAnchor, constant: -10),
            bookmark.leadingAnchor.constraint(equalTo: comment.trailingAnchor, constant: 8),
            bookmark.heightAnchor.constraint(equalToConstant: 23),
            bookmark.widthAnchor.constraint(equalToConstant: 65),
            
            bookmarkIcon.centerYAnchor.constraint(equalTo: bookmark.centerYAnchor),
            bookmarkIcon.leadingAnchor.constraint(equalTo: bookmark.leadingAnchor, constant: 5),
            bookmarkIcon.heightAnchor.constraint(equalToConstant: 16),
            bookmarkIcon.widthAnchor.constraint(equalToConstant: 16),
            
            likeCount.centerYAnchor.constraint(equalTo: like.centerYAnchor),
            likeCount.leadingAnchor.constraint(equalTo: likeIcon.trailingAnchor, constant: 10),
            
            commentCount.centerYAnchor.constraint(equalTo: comment.centerYAnchor),
            commentCount.leadingAnchor.constraint(equalTo: commentIcon.trailingAnchor, constant: 10),
            
            bookmarkCount.centerYAnchor.constraint(equalTo: bookmark.centerYAnchor),
            bookmarkCount.leadingAnchor.constraint(equalTo: bookmarkIcon.trailingAnchor, constant: 10)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func likeAction() {
        
    }
}
