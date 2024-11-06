//
//  HeaderMedicineCollectionReusableView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 23/11/22.
//

import UIKit
import CoreData
import Cosmos
import TinyConstraints

class HeaderMedicineCollectionReusableView: UICollectionReusableView {
    static let identifier = "HeaderMedicineCollectionReusableView"
    var medicinesCollectionViewCell = MedicinesCollectionViewCell()
    var dataModel = [DataModel]()
    var dataBasket = [Basket]()
    var id: String = ""
    var is_favorite: Bool = false
    var title: String = ""
    var images: String = ""
    var prices: String = ""
    var commitPredicate: NSPredicate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    lazy var cosmosView: CosmosView = {
        let cosmos = CosmosView()
        cosmos.settings.minTouchRating = 0.0
        cosmos.rating = 0.0
        cosmos.settings.fillMode = .precise
        cosmos.settings.starMargin = 4.5
        cosmos.translatesAutoresizingMaskIntoConstraints = false
        return cosmos
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var favorite: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var medicineName: UILabel = {
        let medicineName = UILabel()
        medicineName.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        medicineName.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        medicineName.numberOfLines = 3
        medicineName.translatesAutoresizingMaskIntoConstraints = false
        return medicineName
    }()
    
    lazy var note: UILabel = {
        let note = UILabel()
        note.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        note.numberOfLines = 0
        note.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        note.translatesAutoresizingMaskIntoConstraints = false
        return note
    }()
    
    lazy var price: UILabel = {
        let price = UILabel()
        price.textColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        price.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        price.translatesAutoresizingMaskIntoConstraints = false
        return price
    }()
    
    lazy var buttonSave: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.addTarget(self, action: #selector(saveInBasket), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var inStock: UILabel = {
        let inStock = UILabel()
        inStock.textColor = UIColor(red: 0.235, green: 0.902, blue: 0.51, alpha: 1)
        inStock.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        inStock.translatesAutoresizingMaskIntoConstraints = false
        return inStock
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var label3: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var label4: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var label5: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var label6: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var label7: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    lazy var info: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
//        label.text = "Инструкция"
//        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
//    lazy var productDescription: UILabel = {
//        let label = UILabel()
//        label.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
//        label.text = ""
//        label.numberOfLines = 5
//        label.setNeedsDisplay()
//        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureConstraints() {
        addSubview(image)
        addSubview(medicineName)
        addSubview(note)
        addSubview(cosmosView)
        addSubview(price)
        addSubview(favorite)
        addSubview(buttonSave)
        addSubview(inStock)
        addSubview(label)
        addSubview(label2)
        addSubview(label3)
        addSubview(label4)
        addSubview(label5)
        addSubview(label6)
        addSubview(label7)
//        addSubview(productDescription)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            image.centerXAnchor.constraint(equalTo: centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 360),
            image.heightAnchor.constraint(equalToConstant: 360),
            
            favorite.topAnchor.constraint(equalTo: image.topAnchor),
            favorite.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -30),
            favorite.heightAnchor.constraint(equalToConstant: 30),
            favorite.widthAnchor.constraint(equalToConstant: 30),
            
            medicineName.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16),
            medicineName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            medicineName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            note.topAnchor.constraint(equalTo: medicineName.bottomAnchor, constant: 16),
            note.centerXAnchor.constraint(equalTo: centerXAnchor),
            note.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            cosmosView.topAnchor.constraint(equalTo: note.bottomAnchor, constant: 20),
            cosmosView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cosmosView.heightAnchor.constraint(equalToConstant: 40),
            cosmosView.widthAnchor.constraint(equalToConstant: 200),
            
            price.topAnchor.constraint(equalTo: cosmosView.bottomAnchor, constant: 20),
            price.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            buttonSave.topAnchor.constraint(equalTo: cosmosView.bottomAnchor, constant: 11),
            buttonSave.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            buttonSave.widthAnchor.constraint(equalToConstant: 120),
            buttonSave.heightAnchor.constraint(equalToConstant: 45),
            
            inStock.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 16),
            inStock.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            label.topAnchor.constraint(equalTo: inStock.bottomAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            label2.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            label2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 3),
            label3.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            label4.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: 3),
            label4.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            label5.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 11),
            label5.leadingAnchor.constraint(equalTo: label2.trailingAnchor, constant: 3),
            
            label6.topAnchor.constraint(equalTo: label5.bottomAnchor, constant: 7),
            label6.leadingAnchor.constraint(equalTo: label3.trailingAnchor, constant: 3),
            
            label7.topAnchor.constraint(equalTo: label6.bottomAnchor, constant: 7),
            label7.leadingAnchor.constraint(equalTo: label4.trailingAnchor, constant: 3),
            
//            productDescription.topAnchor.constraint(equalTo: label7.bottomAnchor, constant: 20),
//            productDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
//            productDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
            
        ])
    }
    
    func saveMedicine() {
        let data = DataModel(context: self.context)
        data.id = id
        data.title = title
        data.price = prices
        data.image = images
        data.is_favorite = is_favorite
        print(data.id)
        self.dataModel.append(data)
        print("ischecked")
       do {
           try context.save()
       }catch {
           print("Error saving context \(error)")
       }
    }

    func buttonState() {
        let fetchRequest: NSFetchRequest <DataModel> = DataModel.fetchRequest()
        fetchRequest.predicate = commitPredicate
        commitPredicate = NSPredicate(format: "title == %@", title)
        do {
            let data = try context.fetch(fetchRequest)
            for i in data {
                if i.title == title {
                    //print("\(i.title) and \(title)")
                    favorite.setImage(UIImage(named: "heart"), for: .normal)
                }
                else if i.title == nil{
                    favorite.setImage(UIImage(named: "iconHeart"), for: .normal)
                }
            }
        }
        catch {
            print("Error\(error)")
        }
    }

    func deleteMedicine() {
        let object: NSFetchRequest <DataModel> = DataModel.fetchRequest()
        object.predicate = commitPredicate
        commitPredicate = NSPredicate(format: "title == %@", title)
        do {
            let object = try context.fetch(object)
            for i in object {
                if i.title == title {
                    context.delete(i)
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

    @objc func buttonAction() {
        let fetchRequest: NSFetchRequest <DataModel> = DataModel.fetchRequest()
        fetchRequest.predicate = commitPredicate
        commitPredicate = NSPredicate(format: "title == %@", title)
        do{
            let data = try context.fetch(fetchRequest).first
            if data == nil && data?.title != title {
                print("\(data?.title) and \(title)")
                is_favorite = true
                print(is_favorite)
                favorite.setImage(UIImage(named: "heart"), for: .normal)
                print("save")
                saveMedicine()
            }
            else if data?.title == title {
                favorite.setImage(UIImage(named: "iconHeart"), for: .normal)
                print("\(data?.title) and \(title)")
                is_favorite = false
                print(is_favorite)
                print("delete")
                deleteMedicine()
            }
        }
        catch {
            print("Error1\(error)")
        }
    }
    func saveMedicineInBasket() {
        let data = Basket(context: self.context)
        data.id = id
        data.title = title
        data.price = prices
        data.image = images
        print(images)
        print(title)
        self.dataBasket.append(data)
        print("ischecked")
       do {
           try context.save()
       }catch {
           print("Error saving context \(error)")
       }
    }

    func deleteMedicineInBasket() {
        let object: NSFetchRequest <Basket> = Basket.fetchRequest()
        object.predicate = commitPredicate
        commitPredicate = NSPredicate(format: "id == %@", id)
        do {
            let object = try context.fetch(object)
            for i in object {
                if i.id == id {
                    context.delete(i)
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
    
    @objc func saveInBasket() {
        let fetchRequest: NSFetchRequest <Basket> = Basket.fetchRequest()
        fetchRequest.predicate = commitPredicate
        commitPredicate = NSPredicate(format: "title == %@", title)
        do{
            let data = try context.fetch(fetchRequest).first
            if data == nil && data?.title != title {
                print("\(data?.title) and \(title)")
                print("save")
                saveMedicineInBasket()
            }
            else if data?.title == title {
                print("\(data?.title) and \(title)")
                print("delete")
                deleteMedicineInBasket()
            }
        }
        catch {
            print("Error1\(error)")
        }

    }
    
    func cosmos() {
        cosmosView.didTouchCosmos = { rating in
            print(rating)
        }
    }
}
