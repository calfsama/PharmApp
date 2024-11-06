//
//  SubtotalCollectionReusableView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 13/02/23.
//

import UIKit
import CoreData

class SubtotalCollectionReusableView: UICollectionReusableView {
    static let identifier = "SubtotalCollectionReusableView"
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var data = [Basket]()
    var condition: Bool = true
    var deliveryCondition: Bool = false
    var total_price: TotalPrice?
    var disCount: Double = 0.0
    
    lazy var uiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var goods: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "Промежуточный итог"
        label.textColor = UIColor(red: 0.118, green: 0.196, blue: 0.235, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var discount: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "Скидка"
        label.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var discountPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var total: UILabel = {
        let label = UILabel()
        label.text = String(format: "%.2f", calculateCartTotal()) + "сомони"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 0.118, green: 0.196, blue: 0.235, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var delivery: UILabel = {
        let label = UILabel()
        label.text = "Доставка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = UIColor(red: 0.118, green: 0.196, blue: 0.235, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Radiobutton2"), for: .normal)
        button.addTarget(self, action: #selector(conditionButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var button2: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Radiobutton"), for: .normal)
        button.addTarget(self, action: #selector(conditionButton2), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Обычная доставка в течении 3-х часов - 5 сом"
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor(red: 0.118, green: 0.196, blue: 0.235, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.text = "Срочная доставка в течении 45 минут - 20 сом"
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor(red: 0.118, green: 0.196, blue: 0.235, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var uiView6: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 1)
        uiView.layer.cornerRadius = 4
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var totalWithDelivery: UILabel = {
        let label = UILabel()
        label.text = "Общая сумма"
        label.textColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var totalCount: UILabel = {
        let label = UILabel()
//        label.text = String(format: "%.2f", calculateCartTotalWithDelivery()) + " сомони"
        label.textColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func calculateCartTotalWithDelivery() -> Double{
        var total = 0.0
        if self.data.count > 0 {
            for index in 0...self.data.count - 1 {
                total += (Double(data[index].price ?? "") ?? 0) * (Double(data[index].amount!) ?? 0)
            }
        }
        return total - disCount + 5
    }
    
    func calculateCartTotal() -> Double {
        var total = 0.0
        if self.data.count > 0 {
            for index in 0...self.data.count - 1 {
                total += (Double(data[index].price ?? "") ?? 0) * (Double(data[index].amount!) ?? 0)
            }
        }
        return total
    }

    
    func delivery20tjs() -> Double {
        var total = 0.0
        if self.data.count > 0 {
            for index in 0...self.data.count - 1 {
                total += (Double(data[index].price ?? "") ?? 0) * (Double(data[index].amount!) ?? 0)
            }
        }
        return total - disCount + 20
    }
    
    func loadArticles() {
        let request: NSFetchRequest <Basket> = Basket.fetchRequest()
        do {
            data = try context.fetch(request)
        }catch {
            print("Error fetching data from context \(error)")
        }
    }


    
    @objc func conditionButton() {
        if condition == true {
           condition = true
           deliveryCondition = false
           button.setImage(UIImage(named: "Radiobutton2"), for: .normal)
           button2.setImage(UIImage(named: "Radiobutton"), for: .normal)
           print("Find popular")
        }
        else if condition == false {
           condition = true
           button.setImage(UIImage(named: "Radiobutton2"), for: .normal)
            button2.setImage(UIImage(named: "Radiobutton"), for: .normal)
        }
        totalCount.text = String(format: "%.2f", calculateCartTotalWithDelivery()) + " сомони"
        total_price?.update(total_price: String(calculateCartTotalWithDelivery()))
    }
    
    @objc func conditionButton2() {
        if deliveryCondition == true {
            deliveryCondition = true
            condition = false
            button.setImage(UIImage(named: "Radiobutton"), for: .normal)
            button2.setImage(UIImage(named: "Radiobutton2"), for: .normal)
            print("Find popular")
        }
        else if deliveryCondition == false {
            deliveryCondition = true
            button2.setImage(UIImage(named: "Radiobutton2"), for: .normal)
            button.setImage(UIImage(named: "Radiobutton"), for: .normal)
        }
        totalCount.text = String(format: "%.2f", delivery20tjs()) + " сомони"
        total_price?.update(total_price: String(delivery20tjs()))
    }
    
    func configureConstraints() {
        addSubview(uiView)
        uiView.addSubview(goods)
        uiView.addSubview(total)
        addSubview(delivery)
        addSubview(button)
        addSubview(button2)
        addSubview(label)
        addSubview(label2)
        addSubview(uiView6)
        addSubview(totalWithDelivery)
        addSubview(totalCount)
        
        
        NSLayoutConstraint.activate([
            
            uiView.topAnchor.constraint(equalTo: topAnchor),
            uiView.trailingAnchor.constraint(equalTo: trailingAnchor),
            uiView.leadingAnchor.constraint(equalTo: leadingAnchor),
            uiView.heightAnchor.constraint(equalToConstant: 45),
            
            goods.centerYAnchor.constraint(equalTo: uiView.centerYAnchor),
            goods.leadingAnchor.constraint(equalTo: uiView.leadingAnchor, constant: 20),
            
            total.centerYAnchor.constraint(equalTo: uiView.centerYAnchor),
            total.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -20),
            
            delivery.topAnchor.constraint(equalTo: uiView.bottomAnchor, constant: 20),
            delivery.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            button.topAnchor.constraint(equalTo: delivery.bottomAnchor, constant: 15),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            button.heightAnchor.constraint(equalToConstant: 20),
            button.widthAnchor.constraint(equalToConstant: 20),
            
            button2.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
            button2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            button2.heightAnchor.constraint(equalToConstant: 20),
            button2.widthAnchor.constraint(equalToConstant: 20),
            
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 5),
            
            label2.centerYAnchor.constraint(equalTo: button2.centerYAnchor),
            label2.leadingAnchor.constraint(equalTo: button2.trailingAnchor, constant: 5),
            
            uiView6.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 20),
            uiView6.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            uiView6.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            uiView6.heightAnchor.constraint(equalToConstant: 1),
            
            totalWithDelivery.topAnchor.constraint(equalTo: uiView6.bottomAnchor, constant: 20),
            totalWithDelivery.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            totalCount.topAnchor.constraint(equalTo: uiView6.bottomAnchor, constant: 20),
            totalCount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            
        ])
    }
    
    func configure() {
        addSubview(uiView)
        uiView.addSubview(goods)
        uiView.addSubview(total)
        addSubview(delivery)
        addSubview(button)
        addSubview(button2)
        addSubview(label)
        addSubview(label2)
        addSubview(uiView6)
        addSubview(totalWithDelivery)
        addSubview(totalCount)
        addSubview(discount)
        addSubview(discountPrice)
        
        NSLayoutConstraint.activate([
            
            uiView.topAnchor.constraint(equalTo: topAnchor),
            uiView.trailingAnchor.constraint(equalTo: trailingAnchor),
            uiView.leadingAnchor.constraint(equalTo: leadingAnchor),
            uiView.heightAnchor.constraint(equalToConstant: 60),
            
            discount.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 7),
            discount.leadingAnchor.constraint(equalTo: uiView.leadingAnchor, constant: 20),
            
            discountPrice.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -20),
            discountPrice.topAnchor.constraint(equalTo: uiView.topAnchor, constant: 7),
            
            goods.bottomAnchor.constraint(equalTo: uiView.bottomAnchor, constant: -7),
            goods.leadingAnchor.constraint(equalTo: uiView.leadingAnchor, constant: 20),
            
            total.bottomAnchor.constraint(equalTo: uiView.bottomAnchor, constant: -7),
            total.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -20),
            
            delivery.topAnchor.constraint(equalTo: uiView.bottomAnchor, constant: 20),
            delivery.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            button.topAnchor.constraint(equalTo: delivery.bottomAnchor, constant: 15),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            button.heightAnchor.constraint(equalToConstant: 20),
            button.widthAnchor.constraint(equalToConstant: 20),
            
            button2.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
            button2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            button2.heightAnchor.constraint(equalToConstant: 20),
            button2.widthAnchor.constraint(equalToConstant: 20),
            
            label.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: button.trailingAnchor, constant: 5),
            
            label2.centerYAnchor.constraint(equalTo: button2.centerYAnchor),
            label2.leadingAnchor.constraint(equalTo: button2.trailingAnchor, constant: 5),
            
            uiView6.topAnchor.constraint(equalTo: button2.bottomAnchor, constant: 20),
            uiView6.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            uiView6.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            uiView6.heightAnchor.constraint(equalToConstant: 1),
            
            totalWithDelivery.topAnchor.constraint(equalTo: uiView6.bottomAnchor, constant: 10),
            totalWithDelivery.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            
            totalCount.topAnchor.constraint(equalTo: uiView6.bottomAnchor, constant: 10),
            totalCount.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            
        ])
    }
}
