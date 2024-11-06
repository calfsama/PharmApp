//
//  SearchViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 13/03/23.
//

import UIKit
import CoreData
import KeychainAccess

protocol DataFilter: class {
    func data(minimumPrice: String, maximumPrice: String, kind: String, raiting: String)
}

class SearchViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    var collectionView = SearchCollectionView()
    var network = NetworkService()
    var search: Search?
    var basket = [Basket]()
    let keychain = Keychain(service: "tj.info.Salomat")
    var searchController = UISearchController()
    var searchProduct: String = ""
    var commitPredicate: NSPredicate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var min: Int = 0
    var max: Int = 200
    var rating = "Популярное"
    var reloadID = 0
    var kd = ""

    //Создание объектов
    let spinner = UIActivityIndicatorView()
    lazy var empty: UILabel = {
        let label = UILabel()
        label.text = "Пусто"
        label.textColor =  UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    lazy var filterbutton: UIButton = {
        let button =  UIButton()
        button.setImage(UIImage(named: "Filter Horizontal"), for: .normal)
        button.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var backButton: UIButton = {
        let button =  UIButton()
        button.setImage(UIImage(named: "Back button"), for: .normal)
        button.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var navView: UIView = {
        let navView = UIView()
        
        navView.translatesAutoresizingMaskIntoConstraints = false
        return navView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.collectionView.addSubview(spinner)
        collectionView.register(SearchCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchCollectionReusableView.identifier)
        spinner.color = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        spinner.frame = CGRect(x: 160, y: 350, width: 40, height: 40)
        filterbutton.addTarget(self, action: #selector(showCategories), for: .touchUpInside)
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.placeholder = "Поиск"
        searchBar.delegate = self
        searchBar.text = searchProduct
        fetchData()
        hideKeyboard()
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.titleView = navView
        navigationController?.navigationBar.addSubview(navView)
        //setup()
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
    }
    
    
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc override func dismissKeyboard() {
        searchBar.endEditing(true)
    }

    
    @objc func backButtonAction() {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        navView.removeFromSuperview()
        print("back")
        navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadArticles()
        reloadData()
        reloadDataWithFilter()
    }
    
    func configure() {
        view.addSubview(empty)

        NSLayoutConstraint.activate([

            empty.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            empty.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func reloadDataWithFilter() {
        let urlString = "/search/with_price?srch_pr_inp=\(searchProduct)&sort_by=\(kd)&min_price=\(min)&max_price=\(max)&user_id=\(keychain["UserID"] ?? "")"
        print(searchProduct)
        let host = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.network.search(urlString: host) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.search = response
//                self.collectionView.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    func reloadData() {
        let urlString = "/search/?srch_pr_inp=\(searchProduct)&user_id=\(keychain["UserID"] ?? "")"
        let host = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.network.search(urlString: host) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.search = response
//                self.collectionView.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }

    @objc func openFilter() {
        let vc = FilterViewController()
        vc.modalPresentationStyle = .custom
        vc.data = self
        self.present(vc, animated: false)
    }
    
    @objc func showCategories() {
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


    func fetchData() {
        self.configureConstraints()
        spinner.startAnimating()
        let urlString = "/search/?srch_pr_inp=\(searchProduct)&user_id=\(keychain["UserID"] ?? "")"
        let host = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.network.search(urlString: host) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.search = response
                self.collectionView.reloadData()
                self.spinner.stopAnimating()
            case .failure(let error):
                print("error", error)
                self.spinner.stopAnimating()
                self.empty.text = "Ничего не найдено"
                self.configure()
            }
        }
    }

    // Констрейнты
    func configureConstraints() {
        view.addSubview(collectionView)
        //navView.addSubview(backButton)
        navView.addSubview(filterbutton)
        navView.addSubview(searchBar)

        NSLayoutConstraint.activate([
            //backButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
//            backButton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
//            backButton.leadingAnchor.constraint(equalTo: navView.leadingAnchor, constant: 10),
//            backButton.heightAnchor.constraint(equalToConstant: 50),
//            backButton.widthAnchor.constraint(equalToConstant: 25),

            filterbutton.trailingAnchor.constraint(equalTo: navView.trailingAnchor),
            filterbutton.heightAnchor.constraint(equalToConstant: 30),
            filterbutton.widthAnchor.constraint(equalToConstant: 30),
            filterbutton.centerYAnchor.constraint(equalTo: searchBar.centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            collectionView.widthAnchor.constraint(equalTo: view.widthAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            
            navView.heightAnchor.constraint(equalToConstant: (navigationController?.navigationBar.frame.size.height)!),
            navView.widthAnchor.constraint(equalToConstant: view.frame.size.width),

            searchBar.topAnchor.constraint(equalTo: navView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: navView.leadingAnchor, constant: -10),
            searchBar.trailingAnchor.constraint(equalTo: filterbutton.leadingAnchor, constant: -10),
            searchBar.bottomAnchor.constraint(equalTo: navView.bottomAnchor),
        ])
    }
}
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.collectionView.addSubview(spinner)
        self.configureConstraints()
        spinner.startAnimating()
        let urlString = "/search/?srch_pr_inp=\(searchBar.text!)"
        let host = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.network.search(urlString: host) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.searchProduct = searchBar.text!
                self.search = response
                self.collectionView.reloadData()
                self.spinner.stopAnimating()
                self.searchProduct = searchBar.text!
            case .failure(let error):
                print("error", error)
                self.collectionView.removeFromSuperview()
                self.spinner.stopAnimating()
                self.empty.text = "Ничего не найдено"
                self.configure()
            }
        }
    }

    func loadArticles() {
        let request: NSFetchRequest <Basket> = Basket.fetchRequest()
        do {
            basket = try context.fetch(request)
            collectionView.reloadData()
        }catch {
            print("Error fetching data from context \(error)")
        }
    }
}
extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
        if search?.products?.count == 0 {
            emptyLabel.text = "Ничего не найдено"
            emptyLabel.textColor = .gray
            emptyLabel.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
            emptyLabel.textAlignment = NSTextAlignment.center
            collectionView.backgroundView = emptyLabel
            return 0
        }
        else {
            emptyLabel.text = ""
            return search?.products?.count ?? 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MedicinesCollectionViewCell.identifier, for: indexPath) as! MedicinesCollectionViewCell
        let url = "http://salomat.tj/upload_product/"
        let completeURL = url + (search?.products?[indexPath.row].product_pic ?? "")
        cell.image.kf.indicatorType = .activity
        cell.image.kf.setImage(with: URL(string: completeURL))
        cell.title.text = search?.products?[indexPath.row].product_name ?? ""
        cell.price.text = search?.products?[indexPath.row].product_price ?? ""
        cell.id = search?.products?[indexPath.row].id ?? ""
        cell.is_favorite = ((search?.products?[indexPath.row].is_favorite) != nil)
        cell.prices = search?.products?[indexPath.row].product_price ?? ""
        cell.titleMedicine = search?.products?[indexPath.row].product_name ?? ""
        cell.images = search?.products?[indexPath.row].product_pic ?? ""
        cell.count = Int(search?.products?[indexPath.row].total_count_in_store ?? "") ?? 0
        cell.configureConstraints()
        if search?.products?[indexPath.row].is_favorite == false {
            cell.button.setImage(UIImage(named: "favorite"), for: .normal)
            cell.isFav = false
            }
        else if search?.products?[indexPath.row].is_favorite == true{
            cell.button.setImage(UIImage(named: "heart"), for: .normal)
            cell.isFav = true
            }
        cell.reloadData = self
        let fetchRequest: NSFetchRequest <Basket> = Basket.fetchRequest()
        commitPredicate = NSPredicate(format: "id == %@", search?.products?[indexPath.row].id ?? "")
        switch search?.products?[indexPath.row].prod_rating_average {
        case .int(let intValue):
            cell.cosmosView.rating = Double(intValue)
        case .string(let stringValue):
            cell.cosmosView.rating = Double(stringValue) ?? 0
        default: break
        }
        fetchRequest.predicate = commitPredicate
        do {
            let data = try context.fetch(fetchRequest)
            for i in data {
                if i.id == self.search?.products?[indexPath.row].id ?? "" {
                    //print("\(i.title) and \(title)")
                    cell.cartButton.backgroundColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
                    cell.cartButton.setTitle("Убрать из корзины", for: .normal)
                    cell.contentView.layer.borderColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1).cgColor
                }
                else if i.id == nil{
                    cell.cartButton.backgroundColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1)
                    cell.contentView.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
                    cell.cartButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                    cell.cartButton.setTitle("В корзину", for: .normal)
                }
            }
        }
        catch {
            print("Error\(error)")
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchCollectionReusableView.identifier, for: indexPath) as! SearchCollectionReusableView
        header.configure()
        header.ratingButton.setTitle(rating, for: .normal)
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2.3, height: 280)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AboutProductViewController()
        vc.title = search?.products?[indexPath.row].product_name ?? ""
        vc.id = search?.products?[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension SearchViewController: DataFilter {
    func data(minimumPrice: String, maximumPrice: String, kind: String, raiting: String) {
        min = Int(minimumPrice) ?? 0
        max = Int(maximumPrice) ?? 0
        kd = kind
        searchBar.endEditing(true)
        rating = raiting
        reloadID = 1
        print(minimumPrice, "- minimumPrice")
        let urlString = "/search/with_price?srch_pr_inp=\(searchProduct)&sort_by=\(kind)&min_price=\(minimumPrice)&max_price=\(maximumPrice)&user_id=\(keychain["UserID"] ?? "")"
        print(searchProduct)
        let host = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.network.search(urlString: host) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.search = response
                self.collectionView.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }
}
extension SearchViewController: ReloadData {
    func update() {
        if reloadID == 0 {
            reloadData()
        }else if reloadID == 1 {
            reloadDataWithFilter()
        }
    }
}


