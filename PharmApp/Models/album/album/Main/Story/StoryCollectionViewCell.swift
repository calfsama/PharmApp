//
//  StoryCollectionViewCell.swift
//  album
//
//  Created by Tomiris Negmatova on 01/11/22.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
    static let identifier = "StoryCollectionViewCell"
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.cornerRadius = 25
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = UIColor(red: 0.548, green: 0.863, blue: 0.883, alpha: 1)
        contentView.layer.cornerRadius = 23
        contentView.layer.masksToBounds = true
        configureConstraints()
    }
    
    func configureConstraints() {
        contentView.addSubview(image)
        
        NSLayoutConstraint.activate([
            image.widthAnchor.constraint(equalToConstant: contentView.frame.size.width - 5),
            image.heightAnchor.constraint(equalToConstant: contentView.frame.size.height - 5),
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
