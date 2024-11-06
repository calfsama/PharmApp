//
//  ChoosePhotoCollectionReusableView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 27/11/22.
//

import UIKit

class ChoosePhotoCollectionReusableView: UICollectionReusableView {
    static let identifier = "ChoosePhotoCollectionReusableView"
    
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
        addSubview(button)
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
