//
//  MyOrdersCollectionReusableView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 21/10/22.
//

import UIKit
import CoreData

class MyOrdersCollectionReusableView: UICollectionReusableView {
    static let identifier = "MyOrdersCollectionReusableView"
    var order: OrdersData?
    var indexPath: Int = 0
    var dataBasket = [Basket]()
    var gotoCart: RepeatOrder?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var priceOfGoods: UILabel = {
        let label = UILabel()
        label.text = "Стоимость товара:"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var priceOfDelivery: UILabel = {
        let label = UILabel()
        label.text = "Стоимость доставки:"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var price: UILabel = {
        let label = UILabel()
        label.text = "215 сом"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var delivery: UILabel = {
        let label = UILabel()
        label.text = "10 сом"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var totalCount: UILabel = {
        let label = UILabel()
        label.text = "Итого:"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var total: UILabel = {
        let label = UILabel()
        label.text = "225 сом"
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.setTitle("Повторить заказ", for: .normal)
        button.setTitleColor( UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func tapped() {
        loadArticles()
        if dataBasket.count == 0 {
            if (order?[indexPath].products.count ?? 0) > 0 {
                for index in 0...(order?[indexPath].products.count ?? 0) - 1 {
                    save(index: index)
                }
            }
        }
        else if dataBasket.count > 0 {
            resetAllRecords(in: "Basket")
            if (order?[indexPath].products.count ?? 0) > 0 {
                for index in 0...(order?[indexPath].products.count ?? 0) - 1 {
                    save(index: index)
                }
            }
        }
        gotoCart?.update()
    }
    
    func loadArticles() {
        let request: NSFetchRequest <Basket> = Basket.fetchRequest()
        do {
            let data = try context.fetch(request)
            dataBasket = data
        }catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func save(index: Int) {
        let employees = NSEntityDescription.insertNewObject(forEntityName: "Basket", into: context)
        employees.setValue(order?[indexPath].products[index].product_name, forKey: "title")
        employees.setValue(order?[indexPath].products[index].id, forKey: "id")
        employees.setValue(order?[indexPath].products[index].product_pic, forKey: "image")
        employees.setValue(order?[indexPath].products[index].product_price, forKey: "price")
        employees.setValue(order?[indexPath].products[index].total_count, forKey: "amount")
        // employees.setValue(1, forKey: "id")
        do {
            try context.save()
        } catch {
            print("problem saving")
        }
        print(dataBasket, "dataBasket")
    }
    
    func resetAllRecords(in entity : String) // entity = Your_Entity_Name
      {

          let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
          let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
          let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
          do
          {
              try context.execute(deleteRequest)
              try context.save()
          }
          catch
          {
              print ("There was an error")
          }
      }
    
    func configure() {
        backgroundColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 0.2)
        addSubview(priceOfGoods)
        addSubview(price)
        addSubview(priceOfDelivery)
        addSubview(delivery)
        addSubview(total)
        addSubview(button)
        addSubview(totalCount)
        
        NSLayoutConstraint.activate([
            priceOfGoods.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            priceOfGoods.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            price.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            price.leadingAnchor.constraint(equalTo: priceOfGoods.trailingAnchor, constant: 8),
            
            priceOfDelivery.topAnchor.constraint(equalTo: priceOfGoods.bottomAnchor, constant: 15),
            priceOfDelivery.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            delivery.topAnchor.constraint(equalTo: priceOfGoods.bottomAnchor, constant: 15),
            delivery.leadingAnchor.constraint(equalTo: priceOfDelivery.trailingAnchor, constant: 8),
            
            total.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 15),
            total.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            totalCount.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 15),
            totalCount.trailingAnchor.constraint(equalTo: total.leadingAnchor, constant: -10),
        
            button.topAnchor.constraint(equalTo: priceOfDelivery.bottomAnchor, constant: 20),
            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 45)
        
        ])
    }
}
