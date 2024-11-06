//
//  ChoosePhotoCollectionViewCell.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 27/10/22.
//

import UIKit

class ChoosePhotoCollectionViewCell: UICollectionViewCell {
    static let identifier = "ChoosePhotoCollectionViewCell"
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "image 2"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
    
    func configureConstraints() {
        contentView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: contentView.topAnchor),
            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
