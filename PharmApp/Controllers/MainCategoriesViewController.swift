//
//  MainCategoriesViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 10/01/23.
//

import UIKit
import Kingfisher
import KeychainAccess

class MainCategoriesViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    var network = NetworkService()
    var categories: CategoriesProducts?
    var products: [ShowProducts]?
    var data: [Any] = []
    var kind = ""
    var pageNumber: Int = 1
    var id: String = ""
    var min: Int = 0
    var max: Int = 200
    var rating = "Популярное"
    var totalPage = 1
    var medicinesCollectionView: MainCategoriesCollectionView!
    var spinner = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        medicinesCollectionView = MainCategoriesCollectionView(nav: self.navigationController!)
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Filter Horizontal"), style: .plain, target: self, action: #selector(openFilter))
        spinner.color = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        medicinesCollectionView.delegate = self
        medicinesCollectionView.dataSource = self
        spinnerConstraints()
        spinner.startAnimating()
        fetchFromApi(page: 1)
      
    }
    
    func spinnerConstraints() {
        self.view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func configureConstraints() {
        view.addSubview(medicinesCollectionView)
        
        NSLayoutConstraint.activate([
            medicinesCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            medicinesCollectionView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            medicinesCollectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor)
        ])
    }
    func fetchFromApi(page: Int){
        let urlString = "/categories/products/\(id)?page=\(page)&sort_by=\(kind)&user_id=149&min_price=\(min)&max_price=\(max)"
        let host = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.network.mainCategories(urlString: host) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                guard let medicines = response.category_products?.products else {return}
                if response.category_products?.products.count == 0 {
                    print("no data")
                }
                else {
                    self.totalPage = response.category_products?.pages[0].total_pages ?? 0
                }
                self.data.append(contentsOf: medicines)
                self.medicinesCollectionView.reloadData()
                self.spinner.stopAnimating()
                print(medicines)
                self.configureConstraints()
            case .failure(let error):
                print("error", error)
            }
        }
    }
}
extension MainCategoriesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.count == 0 {
            var emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            emptyLabel.text = "Нет товаров"
            emptyLabel.textColor = .gray
            emptyLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
            emptyLabel.textAlignment = NSTextAlignment.center
            collectionView.backgroundView = emptyLabel
            //collectionView.separatorStyle = .none
            return 0
        }
        else {
            return data.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MedicinesCollectionViewCell.identifier, for: indexPath) as! MedicinesCollectionViewCell
        let data = data[indexPath.row] as? ShowProducts
        cell.count = Int(data?.total_count_in_store ?? "") ?? 0
        cell.title.text = data?.product_name ?? ""
        cell.id = data?.id ?? ""
        cell.is_favorite = ((data?.is_favorite) != nil)
        if data?.is_favorite == false {
            cell.button.setImage(UIImage(named: "favorite"), for: .normal)
            }
        else if data?.is_favorite == true{
            cell.button.setImage(UIImage(named: "heart"), for: .normal)
            }
        switch data?.prod_rating_average {
        case .int(let intValue):
            cell.cosmosView.rating = Double(intValue)
        case .string(let stringValue):
            cell.cosmosView.rating = Double(stringValue) ?? 0
        default: break
        }
        cell.titleMedicine = data?.product_name ?? ""
        cell.prices = data?.product_price ?? ""
        cell.images = data?.product_pic ?? ""
        cell.price.text = data?.product_price ?? ""
        let url = "http://salomat.tj/upload_product/"
        let completeURL = url + (data?.product_pic ?? "")
        cell.image.kf.indicatorType = .activity
        cell.image.kf.setImage(with: URL(string: completeURL))
        cell.configureConstraints()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2.3, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AboutProductViewController()
        let data = data[indexPath.row] as? ShowProducts
        vc.title = data?.product_name ?? ""
        vc.id = data?.id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func openFilter() {
        let vc = DoubleSliderViewController()
        vc.data = self
        vc.min = min
        vc.max = max
        vc.rating = self.rating
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {

            if let presentationController = navigationController.presentationController as? UISheetPresentationController {

                if #available(iOS 16.0, *) {
                    presentationController.detents =  [.medium(), .large(), .custom(resolver: {_ in return 280})]
                } else {
                    // Fallback on earlier versions
                }
                self.present(navigationController, animated: true)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if pageNumber < totalPage && indexPath.row == (data.count) - 1 {
            pageNumber = pageNumber + 1
            fetchFromApi(page: pageNumber)
        }
    }
}
extension MainCategoriesViewController: DataFilter {
    func data(minimumPrice: String, maximumPrice: String, kind: String, raiting: String) {
        min = Int(minimumPrice) ?? 0
        max = Int(maximumPrice) ?? 0
        rating = raiting
        self.kind = kind
        pageNumber = 1
        print(minimumPrice, "- minimumPrice")
        print(maximumPrice, "- minimumPrice")
        let urlString = "/categories/products/\(id)?page=\(pageNumber)&sort_by=\(kind)&min_price=\(minimumPrice)&max_price=\(maximumPrice)"
        let host = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.network.mainCategories(urlString: host) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                guard let medicines = response.category_products?.products else {return}
                self.totalPage = response.category_products?.pages[0].total_pages ?? 0
                self.data = medicines
                print(medicines)
                self.medicinesCollectionView.reloadData()
                configureConstraints()
            case .failure(let error):
                print("error", error)
            }
        }
    }
}
