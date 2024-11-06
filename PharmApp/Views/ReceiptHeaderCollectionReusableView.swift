//
//  ReceiptHeaderCollectionReusableView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 11/12/22.
//

import UIKit

class ReceiptHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "ReceiptHeaderCollectionReusableView"
    
    lazy var header: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.text = "Выберите фото рецепта для отправки на расшифровку:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure() {
        addSubview(header)
        
        NSLayoutConstraint.activate([
            header.topAnchor.constraint(equalTo: topAnchor),
            header.leadingAnchor.constraint(equalTo: leadingAnchor),
            header.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
