//
//  BasketFooterCollectionReusableView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 25/10/22.
//

import UIKit
import CoreData

class BasketFooterCollectionReusableView: UICollectionReusableView {
    static let identifier = "BasketFooterCollectionReusableView"
    var promocode: CheckPromocode?
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Активировать промо код"
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.returnKeyType = .next
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        button.layer.cornerRadius = 4
        button.setImage(UIImage(named: "inactive.icon 2"), for: .normal)
        button.addTarget(self, action: #selector(checkPromocode), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var uiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 1)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var orderButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.setTitle("Оформить заказ", for: .normal)
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var uiView2: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .white
        uiView.layer.borderWidth = 1
        uiView.layer.cornerRadius = 4
        uiView.layer.borderColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 1).cgColor
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var costOfGoods: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.text = "Стоимость товаров:"
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var costOfDelivery: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "Стоимость доставки:"
        label.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cost: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var delivery: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var total: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "Итого: "
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var totalCost: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "114 сом."
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc func checkPromocode() {
        promocode?.promocode(promocode: textField.text!)
    }
    
    public func configure() {
        addSubview(uiView2)
        uiView2.addSubview(costOfGoods)
        uiView2.addSubview(costOfDelivery)
        uiView2.addSubview(cost)
        uiView2.addSubview(delivery)
        uiView2.addSubview(uiView)
        uiView2.addSubview(total)
        uiView2.addSubview(totalCost)
        addSubview(textField)
        addSubview(button)
        
        NSLayoutConstraint.activate([
            uiView2.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            uiView2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            uiView2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            uiView2.heightAnchor.constraint(equalToConstant: 120),
            
            textField.topAnchor.constraint(equalTo: uiView2.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -5),
            textField.heightAnchor.constraint(equalToConstant: 45),
            
            button.topAnchor.constraint(equalTo: uiView2.bottomAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 45),
            button.widthAnchor.constraint(equalToConstant: 45),
            
            costOfGoods.topAnchor.constraint(equalTo: uiView2.topAnchor, constant: 20),
            costOfGoods.leadingAnchor.constraint(equalTo: uiView2.leadingAnchor, constant: 16),
            
            costOfDelivery.topAnchor.constraint(equalTo: costOfGoods.bottomAnchor, constant: 10),
            costOfDelivery.leadingAnchor.constraint(equalTo: uiView2.leadingAnchor, constant: 16),
            
            cost.topAnchor.constraint(equalTo: uiView2.topAnchor, constant: 20),
            cost.trailingAnchor.constraint(equalTo: uiView2.trailingAnchor, constant: -16),
            
            delivery.topAnchor.constraint(equalTo: cost.bottomAnchor, constant: 10),
            delivery.trailingAnchor.constraint(equalTo: uiView2.trailingAnchor, constant: -16),
            
            uiView.heightAnchor.constraint(equalToConstant: 1),
            uiView.topAnchor.constraint(equalTo: costOfDelivery.bottomAnchor, constant: 15),
            uiView.leadingAnchor.constraint(equalTo: uiView2.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: uiView2.trailingAnchor),
            
            total.topAnchor.constraint(equalTo: costOfDelivery.bottomAnchor, constant: 30),
            total.leadingAnchor.constraint(equalTo: uiView2.leadingAnchor, constant: 16),
            
            totalCost.topAnchor.constraint(equalTo: delivery.bottomAnchor, constant: 30),
            totalCost.trailingAnchor.constraint(equalTo: uiView2.trailingAnchor, constant: -16)
        ])
    }
}
