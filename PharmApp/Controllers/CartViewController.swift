//
//  BasketViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 01/09/22.
//

import UIKit
import CoreData
import Kingfisher
import KeychainAccess

@objc protocol UpdatePrice: class {
    @objc func update()
}

@objc protocol CheckPromocode: class {
    @objc func promocode(promocode: String)
}

class CartViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    var basketCollectionView = CartCollectionView()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var network = NetworkService()
    var isExpand: Bool = false
    var data = [Basket]()
    var clous: Double?
    var promocodeData: Promocode?
    var commitPredicate: NSPredicate?
    var alert: UIAlertController!
    let keychain = Keychain(service: "tj.info.Salomat")
    
    lazy var promocode: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Активировать промо код"
        textField.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(red: 0.929, green: 0.929, blue: 1, alpha: 1).cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var promocodeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.setImage(UIImage(named: "inactive.icon"), for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.setTitle("Оформить заказ", for: .normal)
        button.layer.cornerRadius = 4
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "favs")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var empty: UILabel = {
        let label = UILabel()
        label.text = "Ваша корзина пуста"
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var message: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.text = "для совершения покупки\n воспользуйтесь каталогом товаров"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var myTargetView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Корзина"
        view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
//        hideKeyboardWhenTappedAround()
        hideKeyboard()
        hideKeyboard2()
        basketCollectionView.delegate = self
        basketCollectionView.dataSource = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardApperence(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        basketCollectionView.keyboardDismissMode = .interactive
    }
    
    func hideKeyboard2() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(disKeyboard))
        view.addGestureRecognizer(swipe)
    }
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(disKeyboard))
//        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func disKeyboard() {
        view.endEditing(true)
  
//        self.basketCollectionView.heightAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
//        continueButton.removeFromSuperview()
////        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if keychain["order"] == "order" {
            let vc = InfoAboutDeliveryViewController()
            vc.title = "Информация о доставке"
            navigationController?.pushViewController(vc, animated: true)
        }
        else {
            print("error order")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadArticles()
        NotificationCenter.default.post(name: NSNotification.Name("loadList"), object: nil)
        if data.count == 0 {
            configure()
            button.removeFromSuperview()
            view.setNeedsDisplay()
            button.setNeedsDisplay()
            
        }
        else if data.count != 0{
            configureConstraints()
        }

    }
    
    
    
    @objc func keyboardApperence(notification: NSNotification){
            if !isExpand{
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardHeight = keyboardFrame.cgRectValue.height
                    let height = keyboardHeight
//                    self.basketCollectionView.frame.origin.y -= height - 110
//                    self.basketCollectionView.heightAnchor.constraint(equalToConstant: view.frame.size.height / 2).isActive = true
//
                    self.button.frame.origin.y -= height - 90
                  
                   
                }
                else{
//                    self.basketCollectionView.contentSize = CGSize(width: self.view.frame.width, height: self.basketCollectionView.frame.height + 500)
                }
                isExpand = true
            }
        }
        @objc func keyboardDisappear(notification: NSNotification){
            if isExpand{
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardHeight = keyboardFrame.cgRectValue.height
                    let height = keyboardHeight
//                    self.basketCollectionView.frame.origin.y += height - 110
//                    self.basketCollectionView.heightAnchor.constraint(equalToConstant: view.frame.size.height).isActive = true
                    self.button.frame.origin.y += height - 90
                }
                else{
//                    self.basketCollectionView.contentSize = CGSize(width: self.view.frame.width, height: self.basketCollectionView.frame.height - 500)
                }
                isExpand = false
            }
        }
    
    func configure() {
        view.addSubview(empty)
        view.addSubview(image)
        view.addSubview(message)
        
        NSLayoutConstraint.activate([
//            empty.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            empty.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            empty.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            empty.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            image.bottomAnchor.constraint(equalTo: empty.topAnchor, constant: -10),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            message.topAnchor.constraint(equalTo: empty.bottomAnchor, constant: 10),
            message.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            message.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func showAlert() {
        self.alert = UIAlertController(title: "", message: "Неверный промокод", preferredStyle: UIAlertController.Style.alert)
        self.present(self.alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
    }

    @objc func dismissAlert(){
        // Dismiss the alert from here
        self.alert.dismiss(animated: true, completion: nil)
    }

    
    func configureConstraints() {
        view.addSubview(basketCollectionView)
        view.addSubview(button)
        button.backgroundColor = UIColor.black
        
        NSLayoutConstraint.activate([
            
//            basketCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
//            basketCollectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            basketCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            basketCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            basketCollectionView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            basketCollectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),

            button.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 45)
        ])
    }

    
    @objc func buttonAction() {
        if keychain["UserID"] == "" {
            if let tabBarController = self.tabBarController {
                tabBarController.selectedIndex = 4
                let keychain = Keychain(service: "tj.info.Salomat")
                keychain["id"] = "Корзина"
            }
        }
        else {
            let vc = InfoAboutDeliveryViewController()
            vc.title = "Информация о доставке"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func loadArticles() {
        let request: NSFetchRequest <Basket> = Basket.fetchRequest()
        do {
            data = try context.fetch(request)
            basketCollectionView.data = data
            basketCollectionView.reloadData()
        }catch {
            print("Error fetching data from context \(error)")
        }
    }
}
extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CartCollectionViewCell.identifier, for: indexPath) as! CartCollectionViewCell
        let url = "http://salomat.tj/upload_product/"
        let completeURL = url + (data[indexPath.row].image ?? "")
        cell.image.kf.setImage(with: URL(string: completeURL))
        cell.image.kf.indicatorType = .activity
        cell.titleMedicine = data[indexPath.row].title ?? ""
        cell.title.text = data[indexPath.row].title
        cell.stepper.value = Double(data[indexPath.row].amount ?? "") ?? 0
        cell.prices = data[indexPath.row].price ?? ""
        cell.price.text = String(format: "%.2f", (Double(data[indexPath.row].amount ?? "") ?? 0) * (Double(data[indexPath.row].price ?? "") ?? 0)) + " сом"
        cell.ml.text = "50 мл"
        cell.art.text = "Арт. 10120"
        cell.updatePrices = self
        cell.stepperValue.text = data[indexPath.row].amount ?? ""
        cell.id = data[indexPath.row].id ?? ""
        cell.removeProductButton.layer.setValue(indexPath.row, forKey: "index")
        cell.removeProductButton.addTarget(self, action: #selector(deleteUser), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height / 9)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
             
         case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CartHeaderCollectionReusableView.identifier, for: indexPath) as! CartHeaderCollectionReusableView
             return header
             
         case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BasketFooterCollectionReusableView.identifier, for: indexPath) as! BasketFooterCollectionReusableView
            footer.cost.text = String(format: "%.2f", calculateCartTotalWithoutDelivery()) + " сом"
            footer.delivery.text = "5.00" + " сом"
            footer.promocode = self
            footer.totalCost.text = String(format: "%.2f", calculateCartTotalWithDelivery()) + " сом"
            footer.configure()
            return footer
             
         default:
             
            fatalError("Unexpected element kind")
         }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if data.count != 0 {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height - 320)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if data.count != 0 {
            return CGSize(width: collectionView.frame.size.width, height: 50)
        }
        return CGSize(width: 0, height: 0)
    }
    func calculateCartTotalWithDelivery() -> Double{
        var total = 0.0
        if self.data.count > 0 {
            for index in 0...self.data.count - 1 {
                total += (Double(data[index].price ?? "") ?? 0) * (Double(data[index].amount!) ?? 0)
            }
        }
        return total + 5
    }
    
    func calculateCartTotalWithoutDelivery() -> Double{
        var total = 0.0
        if self.data.count > 0 {
            for index in 0...self.data.count - 1 {
                total += (Double(data[index].price ?? "") ?? 0) * (Double(data[index].amount!) ?? 0)
            }
        }
        return total
    }
    
    @objc func deleteUser(sender:UIButton) {
        let i : Int = (sender.layer.value(forKey: "index")) as! Int
        let objectToDelete = data.remove(at: i)
            basketCollectionView.reloadData()
        self.context.delete(objectToDelete)
        do {
            try self.context.save()
        } catch {
            print(error)
        }
        if data.count == 0 {
            button.removeFromSuperview()
            basketCollectionView.removeFromSuperview()
            configure()
        }
    }
}
extension CartViewController: UpdatePrice {
    @objc func update() {
        basketCollectionView.reloadData()
    }
}
extension CartViewController: CheckPromocode {
    @objc func promocode(promocode: String) {
        view.endEditing(true)
        let urlString = "/promos?promo_code=\(promocode)"
        let host = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.network.getPromocode(urlString: host) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.promocodeData = response
                if response.status == false {
                    showAlert()
                }
                else if response.status == true {
                    if keychain["UserID"] == "" {
                        if let tabBarController = self.tabBarController {
                            tabBarController.selectedIndex = 4
                            let keychain = Keychain(service: "tj.info.Salomat")
                            keychain["id"] = "Корзина"
                        }
                    }
                    else {
                        let vc = InfoAboutDeliveryViewController()
                        vc.discount = response.data?.discount ?? ""
                        vc.title = "Информация о доставке"
                        self.navigationController?.pushViewController(vc, animated: true)
                        print(self.promocodeData)
                    }
                  
                }
            case .failure(let error):
                showAlert()
                print("error", error)
            }
        }
    }
}


