//
//  MyOrdersCollectionViewCell.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 14/10/22.
//

import UIKit

class MyOrdersCollectionViewCell: UICollectionViewCell {
    static let identifier = "MyOrdersCollectionViewCell"
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var medical: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var amount: UILabel = {
        let label = UILabel()
        label.text = "Количество:"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var count: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var total: UILabel = {
        let label = UILabel()
        label.text = "Итого:"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var price: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var art: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureConstraints() {
        contentView.addSubview(image)
        contentView.addSubview(medical)
        contentView.addSubview(amount)
        contentView.addSubview(total)
        contentView.addSubview(count)
        contentView.addSubview(price)
        contentView.addSubview(art)
        
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            image.heightAnchor.constraint(equalToConstant: 50),
            image.widthAnchor.constraint(equalToConstant: 50),
            
            medical.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            medical.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            medical.widthAnchor.constraint(equalToConstant: 130),
            
            amount.topAnchor.constraint(equalTo: medical.bottomAnchor, constant: 3),
            amount.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            
            total.topAnchor.constraint(equalTo: amount.bottomAnchor, constant: 3),
            total.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            

            count.topAnchor.constraint(equalTo: medical.bottomAnchor, constant: 3),
            count.leadingAnchor.constraint(equalTo: amount.trailingAnchor, constant: 10),
            
            price.topAnchor.constraint(equalTo: count.bottomAnchor, constant: 3),
            price.leadingAnchor.constraint(equalTo: total.trailingAnchor, constant: 10),
            
            art.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 18),
            art.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
}
