//
//  SearchViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 13/03/23.
//

import UIKit
import CoreData

protocol DataFilter: class {
    func data(minimumPrice: String, maximumPrice: String, kind: String)
}

class SearchViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    var collectionView = SearchCollectionView()
    var network = NetworkService()
    var search: Search?
    var basket = [Basket]()
    var searchController = UISearchController()
    var searchProduct: String = ""
    var commitPredicate: NSPredicate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

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
        navView.backgroundColor = .white
        navView.translatesAutoresizingMaskIntoConstraints = false
        return navView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(SearchCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchCollectionReusableView.identifier)
        spinner.color = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        spinner.frame = CGRect(x: 160, y: 350, width: 40, height: 40)
        filterbutton.addTarget(self, action: #selector(openFilter), for: .touchUpInside)
        searchBar.placeholder = "Поиск"
        searchBar.delegate = self
        searchBar.text = searchProduct
        fetchData()
        navigationItem.titleView = navView
        navigationController?.navigationBar.addSubview(navView)
        //setup()
        backButton.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
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
    }
    
    func configure() {
        view.addSubview(empty)

        NSLayoutConstraint.activate([

            empty.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            empty.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    @objc func openFilter() {
        let vc = FilterViewController()
        vc.modalPresentationStyle = .custom
        vc.data = self
        self.present(vc, animated: false)
    }

    func fetchData() {
        self.collectionView.addSubview(spinner)
        self.configureConstraints()
        spinner.startAnimating()
        let urlString = "/search/?srch_pr_inp=\(searchProduct)"
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
            
            collectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
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
        var emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
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
        let url = "http://374315-ca17278.tmweb.ru/upload_product/"
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
        cell.button.setImage(UIImage(named: "favorite"), for: .normal)
        cell.configureConstraints()
        let fetchRequest: NSFetchRequest <Basket> = Basket.fetchRequest()
        commitPredicate = NSPredicate(format: "id == %@", search?.products?[indexPath.row].id ?? "")
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
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2.3, height: 270)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AboutProductViewController()
        vc.title = search?.products?[indexPath.row].product_name ?? ""
        vc.id = search?.products?[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension SearchViewController: DataFilter {
    func data(minimumPrice: String, maximumPrice: String, kind: String) {
        print(minimumPrice, "- minimumPrice")
        let urlString = "/search/with_price?srch_pr_inp=\(searchProduct)&min_price=\(minimumPrice)&max_price=\(maximumPrice)"
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


