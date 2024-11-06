//
//  Expanding.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 22/12/22.
//

import UIKit
import Kingfisher
import KeychainAccess

@objc protocol RepeatOrder: class {
    @objc func update()
}

struct SectionData {
    var title: OrdersData?
    var expanded: Bool
}

class Expanding: UIViewController, UICollectionViewDelegateFlowLayout {
    var isCollapse: Bool = false
    var isExpanded = [Bool]()
    var order: OrdersData?
    var orderData: Orders?
    var expand = ExpandingCollectionView()
    var network = NetworkService()
    let keychain = Keychain(service: "tj.info.Salomat")
    let indicator = UIActivityIndicatorView()
    var pending = UIAlertController()
    var spinner =  UIActivityIndicatorView()
    var expandSection = [Bool]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        indicator.center = view.center
        isExpanded = Array(repeating: false, count: (order?.count ?? 0) + 1)
        indicator.color = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        view.addSubview(indicator)
        expand.delegate = self
        expand.dataSource = self
        indicator.startAnimating()
        orders()
    }
    
    func configureConstraints() {
        view.addSubview(expand)
        
        NSLayoutConstraint.activate([
            expand.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 30),
            expand.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            expand.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            expand.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    
    func orders(){
        let urlString = "/products/user_orders/\(keychain["UserID"] ?? "")"
        self.network.order(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.order = response
                print(result)
                self.expand.reloadData()
                self.indicator.stopAnimating()
                self.expandSection = [Bool](repeating: false, count: response.count)
                self.configureConstraints()
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")

        if let date = inputFormatter.date(from: dateString) {

            let outputFormatter = DateFormatter()
          outputFormatter.dateFormat = format

            return outputFormatter.string(from: date)
        }

        return nil
    }
    
    func showSpinner() {
        pending = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        //create an activity indicator
        spinner = UIActivityIndicatorView(frame: pending.view.bounds)
        spinner.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //add the activity indicator as a subview of the alert controller's view
        pending.view.addSubview(spinner)
        spinner.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
        spinner.startAnimating()
        
        self.present(pending, animated: true, completion: nil)
    }

    @objc func dismissSpinner(){
        // Dismiss the alert from here1
        self.pending.dismiss(animated: true, completion: nil)
        if let tabBarController = self.tabBarController {
             tabBarController.selectedIndex = 3
        }
    }
}
extension Expanding: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if order?.count == 0 {
            var emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            emptyLabel.text = "Нет заказов"
            emptyLabel.textColor = .gray
            emptyLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
            emptyLabel.textAlignment = NSTextAlignment.center
            collectionView.backgroundView = emptyLabel
            //collectionView.separatorStyle = .none
            return 0
        }
        else {
            return order?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.expandSection[section] == true {
            return (order?[section].products.count ?? 0) + 1
        }
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExpandingCollectionViewCell.identifier, for: indexPath) as! ExpandingCollectionViewCell
            cell.id.text = order?[indexPath.section].order?.id ?? ""
            cell.condition.setTitle(order?[indexPath.section].status[0].status_text ?? "", for: .normal)
            let date = formattedDateFromString(dateString: order?[indexPath.section].order?.created_at ?? "", withFormat: "dd.MM.yy")
            cell.date.text = date
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = UIColor(red: 0.929, green: 0.929, blue: 1, alpha: 1).cgColor
            if self.expandSection[indexPath.section] == true {
                cell.arrowButton.setImage(UIImage(named: "vector-arrow"), for: .normal)
            }
            else if self.expandSection[indexPath.section] == false {
                cell.arrowButton.setImage(UIImage(named: "arrow-vector"), for: .normal)
            }
            if (order?[indexPath.section].status[0].status_text ?? "") == "В ожидании" {
                cell.condition.setTitleColor(UIColor(red: 1, green: 0.762, blue: 0.383, alpha: 1), for: .normal)
                cell.condition.layer.borderColor = UIColor(red: 1, green: 0.762, blue: 0.383, alpha: 1).cgColor
            }
            else if (order?[indexPath.section].status[0].status_text ?? "") == "Отменен" {
                cell.condition.setTitleColor(UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1), for: .normal)
                cell.condition.layer.borderColor =  UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            }
            else if (order?[indexPath.section].status[0].status_text ?? "") == "На обработку" {
                cell.condition.setTitleColor(UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1), for: .normal)
                cell.condition.layer.borderColor =  UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1).cgColor
            }
            else if (order?[indexPath.section].status[0].status_text ?? "") == "Доставлен" {
                cell.condition.setTitleColor(UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1), for: .normal)
                cell.condition.layer.borderColor =  UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1).cgColor
            }
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyOrdersCollectionViewCell.identifier, for: indexPath) as! MyOrdersCollectionViewCell
            cell.contentView.layer.borderWidth = 1
            cell.contentView.layer.borderColor = UIColor(red: 0.929, green: 0.929, blue: 1, alpha: 1).cgColor
            cell.medical.text = order?[indexPath.section].products[indexPath.row - 1].product_name ?? ""
            cell.count.text = (order?[indexPath.section].products[indexPath.row - 1].total_count ?? "") + " шт."
            cell.price.text = (order?[indexPath.section].products[indexPath.row - 1].product_price ?? "") + " сом."
            let url = "http://salomat.tj/upload_product/"
            let completeURL = url + (order?[indexPath.section].products[indexPath.row - 1].product_pic ?? "")
            cell.image.kf.indicatorType = .activity
            cell.image.kf.setImage(with: URL(string: completeURL))
            cell.art.text = "Арт. " + (order?[indexPath.section].products[indexPath.row - 1].product_articule ?? "")
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.expandSection[indexPath.section] == true && indexPath.row > 0{
            return CGSize(width: collectionView.frame.size.width, height: 80)
        }
        return CGSize(width: collectionView.frame.size.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: MyOrdersCollectionReusableView.identifier, for: indexPath) as! MyOrdersCollectionReusableView
        if self.expandSection[indexPath.section] == true {
            footer.configure()
            footer.order = order
            footer.gotoCart = self
            footer.indexPath = indexPath.section
            footer.layer.borderWidth = 1
            footer.layer.borderColor = UIColor(red: 0.929, green: 0.929, blue: 1, alpha: 1).cgColor
            footer.price.text = String((Double(order?[indexPath.section].order?.total_price ?? "") ?? 0) - (Double(order?[indexPath.section].delivery[indexPath.row].delivery_price ?? "") ?? 0)) + " сом"
            footer.delivery.text = String(Double(order?[indexPath.section].delivery[indexPath.row].delivery_price ?? "") ?? 0) + " сом"
            footer.total.text = (String(Double(order?[indexPath.section].order?.total_price ?? "") ?? 0)) + " сом"
        }
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.expandSection[section] {
            return CGSize(width: collectionView.frame.size.width, height: 140)
        }
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            collectionView.deselectItem(at: indexPath, animated: true)
            self.expandSection[indexPath.section] = !self.expandSection[indexPath.section]
    //        self.expand.reloadItems(at: collectionView.indexPathsForSelectedItems!)
            collectionView.reloadSections([indexPath.section])
        }
        else {
            let vc = AboutProductViewController()
            vc.title = order?[indexPath.section].products[indexPath.row - 1].product_name ?? ""
            vc.id = order?[indexPath.section].products[indexPath.row - 1].id ?? ""
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        if indexPath.row == 0 && isCollapse == true  {
//            isCollapse = false
//            isExpanded[indexPath.section] = false
//            let sections = IndexSet.init(integer: indexPath.section)
//            collectionView.reloadSections(sections)
//        }
//        else if indexPath.row == 0 && isCollapse == false {
////        isExpanded[indexPath.section] = !isExpanded[indexPath.section]
//        isCollapse = !isCollapse
//            isExpanded[indexPath.section] == true
//            let sections = IndexSet.init(integer: indexPath.section)
//            collectionView.reloadSections([sections])
//        }
//        if indexPath.row == 0 && self.expandSection[indexPath.row] == true {
//            self.expandSection[indexPath.row] = false
//            let sections = IndexSet.init(integer: indexPath.section)
//            collectionView.reloadSections(sections)
//        }
//        else if indexPath.row == 0 && self.expandSection[indexPath.row] == false{
//            self.expandSection[indexPath.row] = true
//            let sections = IndexSet.init(integer: indexPath.section)
////        }
//        self.expandSection[indexPath.section] = !self.expandSection[indexPath.section]
////        self.expand.reloadItems(at: collectionView.indexPathsForSelectedItems!)
//        collectionView.reloadSections([indexPath.section])

    }
}
extension Expanding: RepeatOrder {
    @objc func update() {
        showSpinner()
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(dismissSpinner), userInfo: nil, repeats: false)
    }
}


