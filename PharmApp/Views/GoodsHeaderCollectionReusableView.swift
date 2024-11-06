//
//  GoodsHeaderCollectionReusableView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 13/02/23.
//

import UIKit

class GoodsHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "GoodsHeaderCollectionReusableView"
    
    lazy var uiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 1)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var uiView2: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 1)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var uiView3: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 1)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var uiView4: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 1)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var goods: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "Товар"
        label.textColor = UIColor(red: 0.118, green: 0.196, blue: 0.235, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var total: UILabel = {
        let label = UILabel()
        label.text = "Всего"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(red: 0.118, green: 0.196, blue: 0.235, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func configure() {
        addSubview(goods)
        addSubview(total)
        addSubview(uiView)
        addSubview(uiView2)
        addSubview(uiView3)
        addSubview(uiView4)
        
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: topAnchor),
            uiView.leadingAnchor.constraint(equalTo: leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: trailingAnchor),
            uiView.heightAnchor.constraint(equalToConstant: 1),
            
            uiView2.topAnchor.constraint(equalTo: topAnchor),
            uiView2.leadingAnchor.constraint(equalTo: leadingAnchor),
            uiView2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4),
            uiView2.widthAnchor.constraint(equalToConstant: 1),
            
            uiView3.topAnchor.constraint(equalTo: topAnchor),
            uiView3.trailingAnchor.constraint(equalTo: trailingAnchor),
            uiView3.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 4),
            uiView3.widthAnchor.constraint(equalToConstant: 1),
            
            uiView4.bottomAnchor.constraint(equalTo: bottomAnchor),
            uiView4.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            uiView4.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            uiView4.heightAnchor.constraint(equalToConstant: 1),
            
            goods.centerYAnchor.constraint(equalTo: centerYAnchor),
            goods.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            total.centerYAnchor.constraint(equalTo: centerYAnchor),
            total.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
}
