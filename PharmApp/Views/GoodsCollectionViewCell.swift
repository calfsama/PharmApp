//
//  GoodsCollectionViewCell.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 14/10/22.
//

import UIKit

class GoodsCollectionViewCell: UICollectionViewCell {
    static let identifier = "GoodsCollectionViewCell"
    
    lazy var uiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 1)
        uiView.layer.cornerRadius = 4
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var uiView2: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 1)
        uiView.layer.cornerRadius = 4
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var medical: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var amount: UILabel = {
        let label = UILabel()
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
    
    func configureConstraints() {
        contentView.addSubview(medical)
        contentView.addSubview(amount)
        contentView.addSubview(price)
        contentView.addSubview(uiView)
        contentView.addSubview(uiView2)
        
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: contentView.topAnchor),
            uiView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
            uiView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            uiView.widthAnchor.constraint(equalToConstant: 1),
            
            uiView2.topAnchor.constraint(equalTo: contentView.topAnchor),
            uiView2.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 20),
            uiView2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            uiView2.widthAnchor.constraint(equalToConstant: 1),
            
            medical.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            medical.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            medical.widthAnchor.constraint(equalToConstant: 110),
            
            
            amount.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
           
            //tamount.trailingAnchor.constraint(equalTo: price.leadingAnchor, constant: -10),
            amount.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            price.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            price.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }   
}
