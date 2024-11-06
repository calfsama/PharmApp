//
//  CartHeaderCollectionReusableView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 29/11/22.
//

import UIKit

class CartHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "CartHeaderCollectionReusableView"
        
    lazy var uiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
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
    
    lazy var uiView3: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 1)
        uiView.layer.cornerRadius = 4
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureConstraints()
    }
    
    func configureConstraints() {
        addSubview(uiView)
        addSubview(uiView2)
        addSubview(uiView3)
        
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            uiView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            uiView.heightAnchor.constraint(equalToConstant: 3),
            uiView.widthAnchor.constraint(equalToConstant: frame.size.width / 3.4),
            
            uiView2.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            //uiView2.leadingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: 11),
            uiView2.centerXAnchor.constraint(equalTo: centerXAnchor),
            uiView2.heightAnchor.constraint(equalToConstant: 3),
            uiView2.widthAnchor.constraint(equalToConstant: frame.size.width / 3.4),
            
            uiView3.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            uiView3.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            uiView3.heightAnchor.constraint(equalToConstant: 3),
            uiView3.widthAnchor.constraint(equalToConstant: frame.size.width / 3.4),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
