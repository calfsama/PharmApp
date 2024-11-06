//
//  MessangerCollectionViewCell.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 27/10/22.
//

import UIKit

class MessangerCollectionViewCell: UICollectionViewCell {
    static let identifier = "MessangerCollectionViewCell"
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 4
        configureConstraints()
    }
    
    func configureConstraints() {
        contentView.addSubview(button)
        contentView.addSubview(image)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

        ])
    }
 
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
