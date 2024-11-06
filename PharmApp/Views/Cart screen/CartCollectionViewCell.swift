//
//  BasketCollectionViewCell.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 10/10/22.
//

import UIKit
import CoreData


class CartCollectionViewCell: UICollectionViewCell {
    static let identifier = "BasketCollectionViewCell"
    var dataModel = [Basket]()
    var cart = CartCollectionView()
    var id: String = ""
    var is_favorite: Bool = false
    var titleMedicine: String = ""
    var images: String = ""
    var prices: String = ""
    var index = Int()
    var priceLabel = ""
    var commitPredicate: NSPredicate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var updatePrices: UpdatePrice?
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var title: UILabel = {
        let title = UILabel()
        title.font =
        UIFont.systemFont(ofSize: 12, weight: .semibold)
        title.textColor =  UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var ml: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var art: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stepper: UIStepper = {
        let stepper = UIStepper()
        stepper.minimumValue = 1
        stepper.maximumValue = 100
        stepper.value = 1
        stepper.tintColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 1)
        stepper.tintColorDidChange()
        stepper.transform = stepper.transform.scaledBy(x: 0.8, y: 0.7)
        stepper.addTarget(self, action: #selector(update), for: .valueChanged)
        stepper.translatesAutoresizingMaskIntoConstraints = false
        return stepper
    }()
    
    lazy var price: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var stepperValue: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "\(Int(stepper.value))"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var removeProductButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        configureConstraints()
    }
    
    func configureConstraints() {
        print(titleMedicine)
        contentView.addSubview(image)
        contentView.addSubview(title)
        contentView.addSubview(ml)
        contentView.addSubview(art)
        contentView.addSubview(stepper)
        contentView.addSubview(stepperValue)
        contentView.addSubview(price)
        contentView.addSubview(removeProductButton)
        
        NSLayoutConstraint.activate([
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            image.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            image.heightAnchor.constraint(equalToConstant: 50),
            image.widthAnchor.constraint(equalToConstant: 50),
            
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: removeProductButton.trailingAnchor, constant: -20),
            
            ml.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3),
            ml.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            
            art.topAnchor.constraint(equalTo: ml.bottomAnchor, constant: 3),
            art.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            
            stepper.centerYAnchor.constraint(equalTo: price.centerYAnchor),
//            stepper.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stepper.leadingAnchor.constraint(equalTo: art.trailingAnchor, constant: 15),

            stepperValue.centerYAnchor.constraint(equalTo: stepper.centerYAnchor),
            stepperValue.centerXAnchor.constraint(equalTo: stepper.centerXAnchor),
            
            price.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            price.trailingAnchor.constraint(equalTo: removeProductButton.leadingAnchor, constant: -20),
            
            removeProductButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            removeProductButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func update() {
        stepperValue.text = "\(Int(stepper.value))"
        updatePrice()
    }
    func updateAmount() {
        let object: NSFetchRequest <Basket> = Basket.fetchRequest()
        commitPredicate = NSPredicate(format: "id == %@", id)
        object.predicate = commitPredicate
        do {
            let object = try context.fetch(object)
            for i in object {
                if i.id == id {
                    i.amount = stepperValue.text
                }
                do {
                    try context.save()
                }catch {
                    print("Error1 \(error)")
                }
            }
        }
        catch {
            print("Error2 \(error)")
        }
    }
    
    func updatePrice() {
        if self.stepper.value >= 1 {
            let productPrice = Double(self.prices)
            price.text = String(format: "%.2f", productPrice! * Double(stepperValue.text!)!) + " сом"
            updatePrices?.update()
            updateAmount()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


