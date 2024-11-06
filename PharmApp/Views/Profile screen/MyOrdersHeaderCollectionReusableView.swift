//
//  MyOrdersHeaderCollectionReusableView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 21/10/22.
//

import UIKit

class MyOrdersHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "MyOrdersHeaderCollectionReusableView"
    
    lazy var count: UILabel = {
        let label = UILabel()
        label.text = "51002"
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var condition: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 15
        button.backgroundColor = .white
        button.setTitle("Доставлено", for: .normal)
        button.setTitleColor(UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1).cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var date: UILabel = {
        let label = UILabel()
        label.text = "21.10.22"
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public func configure() {
        backgroundColor = .white
        layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        layer.borderWidth = 1
        addSubview(count)
        addSubview(condition)
        addSubview(date)
        
        NSLayoutConstraint.activate([
            count.centerYAnchor.constraint(equalTo: centerYAnchor),
            count.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            condition.centerYAnchor.constraint(equalTo: centerYAnchor),
            condition.leadingAnchor.constraint(equalTo: count.trailingAnchor, constant: 20),
            condition.heightAnchor.constraint(equalToConstant: 30),
            condition.widthAnchor.constraint(equalToConstant: 80),
            
            date.centerYAnchor.constraint(equalTo: centerYAnchor),
            date.leadingAnchor.constraint(equalTo: condition.trailingAnchor, constant: 20)
        ])
    }
}
