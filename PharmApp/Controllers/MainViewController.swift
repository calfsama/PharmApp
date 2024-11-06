//
//  MainViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 01/09/22.
//

import UIKit
import SkeletonView
import CoreData
import KeychainAccess
import Kingfisher

protocol MedicineFromCategory{
     func update(id: String, name: String, subCat: [SubCat]?)
}
protocol OpenCategories {
    func openCategories()
}

class MainViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    var text: String = ""
    var url: String = ""
    var timer = Timer()
    var commitPredicate: NSPredicate?
    var dataModel = [DataModel]()
    var banners: MainSliders?
    var basket = [Basket]()
    var counter = 0
    var counter2 = 0
    var categories: Category?
    let keychain = Keychain(service: "tj.info.Salomat")
    var initialScrollDone: Bool = true
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var searchController = UISearchController(searchResultsController: nil)
    let searchControl = UISearchController(searchResultsController: nil)
    var banner: CategoriesForMainPage?
    
    lazy var searchBarView: UIView = {
        let uiview = UIView()
        uiview.backgroundColor = .white
        uiview.translatesAutoresizingMaskIntoConstraints = false
        return uiview
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.placeholder = "Поиск"
        searchBar.isTranslucent = false
        searchBar.delegate = self
        searchBar.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    lazy var uiscrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 1850)
        scrollView.backgroundColor = .white
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(openBlogList), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()


    var categoryCollectionView: CategoryCollectionView!
    var bannersCollectionView: BannerCollectionView!
    var itemsCollectionView: ItemsCollectionView!
    var bannerMedicineCollectionView: BannerMedicineCollectionView!
    var medicinalProductsCollectionView: MedicinalProductsCollectionView!
    var blogCollectionView: BlogCollectionView!
    var vitaminCollectionView: VitaminCollectionView!
    var badsCollectionView: BADCollectionView!
    var network = NetworkService()
    var product: ProdsOfTheDay?
    
    lazy var header: UIView = {
        let header = UIView()
        header.backgroundColor = .white
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    lazy var header2: UIView = {
        let header = UIView()
        header.backgroundColor = .white
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    lazy var header3: UIView = {
        let header = UIView()
        header.backgroundColor = .white
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    lazy var header4: UIView = {
        let header = UIView()
        header.backgroundColor = .white
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    lazy var label: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        title.text = "Товары дня"
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var label2: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        title.text = "Лекарственные средства"
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var label3: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        title.text = "Блог"
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var label4: UILabel = {
        let title = UILabel()
        title.textColor = .white
        title.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        title.text = "Все статьи"
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var header5: UIView = {
        let header = UIView()
        header.backgroundColor = .white
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    lazy var label5: UILabel = {
        let title = UILabel()
        title.textColor = .black
        title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        title.text = "Витамины и БАД"
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var allArticles: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitle("Все статьи>", for: .normal)
        button.addTarget(self, action: #selector(openBlogList), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var link: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Group"), for: .normal)
        button.addTarget(self, action: #selector(openLink), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var instagram: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Instagram"), for: .normal)
        button.addTarget(self, action: #selector(openInstagram), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var facebook: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "facebook"), for: .normal)
        button.addTarget(self, action: #selector(openFacebook), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var telegram: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "telegram"), for: .normal)
        button.addTarget(self, action: #selector(openTelegram), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var filter: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Filter Horizontal"), for: .normal)
        button.addTarget(self, action: #selector(showMainCategories), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var filterForVitamin: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Filter Horizontal"), for: .normal)
        button.addTarget(self, action: #selector(showMainCategories), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        searchBar.searchBarStyle = .minimal
        bannersCollectionView = BannerCollectionView(nav: self.navigationController!)
        bannerMedicineCollectionView = BannerMedicineCollectionView(nav: self.navigationController!)
        vitaminCollectionView = VitaminCollectionView(nav: self.navigationController!)
        categoryCollectionView = CategoryCollectionView(nav: self.navigationController!)
        blogCollectionView = BlogCollectionView(nav: self.navigationController!)
        itemsCollectionView = ItemsCollectionView(nav: self.navigationController!)
        medicinalProductsCollectionView = MedicinalProductsCollectionView(nav: self.navigationController!)
        badsCollectionView = BADCollectionView(nav: self.navigationController!)
        configureConstraints()
        itemsCollectionView.delegate = self
        itemsCollectionView.dataSource = self
        itemsCollectionView.register(MedicinesCollectionViewCell.self, forCellWithReuseIdentifier: MedicinesCollectionViewCell.identifier)
        categoryCollectionView.set(cells: Categories.items())
//        hideKeyboard()
        hideKeyboard2()
        fetchFromApi()
        fetchData()
//        fetchBlogData()
        fetchBanner()
//        startTimer()
        favorites()
        fetchVitamin()
        fetchCategories()
//        itemsCollectionView.showAnimatedGradientSkeleton()
//        medicinalProductsCollectionView.showAnimatedGradientSkeleton()
        loadBasketData()
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
            self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.changeMainSliderImage), userInfo: nil, repeats: true)
        }

//        itemsCollectionView.showAnimatedGradientSkeleton()
  
//        let logo = UIImage(named: "logo 2")
//        let imageView = UIImageView(image:logo)
//        self.navigationItem.titleView = imageView
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "menu"), style: .plain, target: self, action: #selector(showMainCategories))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "ph_phone-light"), style: .plain, target: self, action: #selector(clicked))
//        if let tabItems = tabBarController?.tabBar.items {
//            // In this case we want to modify the badge number of the third tab:
//            let tabItem = tabItems[3]
//            tabItem.badgeValue = String(basket.count)
//            tabItem.badgeColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
//        }
//        let string = "https://salomat.tj/index.php/main/searchProductResult?srch_pr_inp=%D0%B8%D0%BD%D1%81%D1%82%D0%B8"
//        let components = NSURL(fileURLWithPath: string).pathComponents!.dropFirst()
//        print(components[4], "components")
    }
    func favorites(){
        let urlString = "/favorites?user_id=\(keychain["UserID"] ?? "")"
        self.network.favorites(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.medicinalProductsCollectionView.favorites = response
                self.medicinalProductsCollectionView.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    @objc func clicked() {
        guard let number = URL(string: "tel://" + "+992446309990") else { return }
        UIApplication.shared.open(number)
    }
    
    @objc func searchClose() {
        searchBarView.removeFromSuperview()
        hideKeyboardWhenTappedAround()
    }
    
    @objc func changeMainSliderImage() {
     
        if counter2 < (banners?.main_slider?.count ?? 0){
         let index = IndexPath.init(item: counter2, section: 0)
         self.bannersCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
         counter2 += 1
     } else {
         counter2 = 0
         let index = IndexPath.init(item: counter2, section: 0)
         self.bannersCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
         counter2 = 1
     }
         
     }

    
    @objc func changeImage() {
     
     if counter < (banner?.categories_for_main_page?[0].categ_slider?.count ?? 0){
         let index = IndexPath.init(item: counter, section: 0)
         self.bannerMedicineCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
         counter += 1
     } else {
         counter = 0
         let index = IndexPath.init(item: counter, section: 0)
         self.bannerMedicineCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
         counter = 1
     }
         
     }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBasketData()
        loadFavoriteData()
        fetchFromApi()
        fetchData()
        favorites()
        fetchVitamin()
        fetchCategories()
    }
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(disKeyboard))
//        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func disKeyboard() {
        view.endEditing(true)
        searchBar.endEditing(true)
//        searchBarView.removeFromSuperview()
    }
    
    func hideKeyboard2() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(disKeyboard))
        view.addGestureRecognizer(swipe)
    }
    
    @objc func openBlogList() {
        let vc = BlogListViewController()
        vc.title = "Блог"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
     @objc func scrollToNextCell(){
         //get cell size
         let cellSize = CGSizeMake(self.view.frame.width, self.view.frame.height);

         //get current content Offset of the Collection view
         let contentOffset = bannersCollectionView.contentOffset;

         //scroll to next cell
         bannersCollectionView.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width - 48, contentOffset.y, cellSize.width, cellSize.height), animated: true);
         bannerMedicineCollectionView.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width - 48, contentOffset.y, cellSize.width, cellSize.height), animated: true);
//         vitaminCollectionView.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width - 48, contentOffset.y, cellSize.width, cellSize.height), animated: true);
         
         if bannersCollectionView.contentSize.width <= bannersCollectionView.contentOffset.x + self.view.frame.width {
             bannersCollectionView.scrollRectToVisible(CGRectMake(contentOffset.x + cellSize.width - 48, contentOffset.y, cellSize.width, cellSize.height), animated: true);
         }
     }
    
    @objc func searchView() {
        navigationController?.navigationBar.addSubview(searchBarView)
        searchBarView.addSubview(searchBar)
        searchBar.delegate = self
        searchBar.text = ""
        NSLayoutConstraint.activate([
            searchBarView.heightAnchor.constraint(equalToConstant: (navigationController?.navigationBar.frame.size.height)!),
            searchBarView.widthAnchor.constraint(equalToConstant: view.frame.size.width),
            
            searchBar.topAnchor.constraint(equalTo: searchBarView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor, constant: -10),
            searchBar.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor),
            
        ])
    }
  
    func startTimer() {
        let timer =  Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    @objc func openSearchController() {
        let v = SearchViewController()
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    func loadBasketData() {
        let request: NSFetchRequest <Basket> = Basket.fetchRequest()
        do {
            basket = try context.fetch(request)
            itemsCollectionView.basket = basket
            medicinalProductsCollectionView.basket = basket
            badsCollectionView.basket = basket
            badsCollectionView.reloadData()
            medicinalProductsCollectionView.reloadData()
            itemsCollectionView.reloadData()
        }catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func loadFavoriteData() {
        let dataRequest: NSFetchRequest <DataModel> = DataModel.fetchRequest()
        do {
            dataModel = try context.fetch(dataRequest)
            itemsCollectionView.data = dataModel
            itemsCollectionView.reloadData()
        }catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func configureConstraints() {
        view.addSubview(uiscrollView)
        uiscrollView.addSubview(searchBar)
        uiscrollView.addSubview(categoryCollectionView)
        uiscrollView.addSubview(bannersCollectionView)
        uiscrollView.addSubview(itemsCollectionView)
        uiscrollView.addSubview(bannerMedicineCollectionView)
        uiscrollView.addSubview(header)
        uiscrollView.addSubview(label)
        uiscrollView.addSubview(header2)
        uiscrollView.addSubview(label2)
        uiscrollView.addSubview(medicinalProductsCollectionView)
//        uiscrollView.addSubview(header3)
//        uiscrollView.addSubview(label3)
//        uiscrollView.addSubview(blogCollectionView)
//        uiscrollView.addSubview(header4)
//        uiscrollView.addSubview(button)
//        uiscrollView.addSubview(label4)
//        uiscrollView.addSubview(header5)
//        uiscrollView.addSubview(label5)
//        uiscrollView.addSubview(vitaminCollectionView)
//        uiscrollView.addSubview(badsCollectionView)
//        uiscrollView.addSubview(allArticles)
//        uiscrollView.addSubview(link)
//        uiscrollView.addSubview(instagram)
//        uiscrollView.addSubview(facebook)
//        uiscrollView.addSubview(telegram)
        uiscrollView.addSubview(filter)
//        uiscrollView.addSubview(filterForVitamin)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: uiscrollView.topAnchor, constant: 10),
            searchBar.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor, constant: 8),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            
            categoryCollectionView.topAnchor.constraint(equalTo:  bannersCollectionView.bottomAnchor, constant: 10),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 110),
            categoryCollectionView.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            bannersCollectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            bannersCollectionView.heightAnchor.constraint(equalToConstant: 200),
            bannersCollectionView.widthAnchor.constraint(equalToConstant: uiscrollView.frame.size.width - 32),
            bannersCollectionView.centerXAnchor.constraint(equalTo: uiscrollView.centerXAnchor),
            
            header.heightAnchor.constraint(equalToConstant: 30),
            header.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor),
            header.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 25),
            
            label.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            label.topAnchor.constraint(equalTo: header.topAnchor),
            
            itemsCollectionView.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor),
            itemsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            itemsCollectionView.heightAnchor.constraint(equalToConstant: 300),
            itemsCollectionView.topAnchor.constraint(equalTo: header.bottomAnchor),
            
            header2.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor),
            header2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            header2.topAnchor.constraint(equalTo: itemsCollectionView.bottomAnchor, constant: 20),
            header2.heightAnchor.constraint(equalToConstant: 30),
            
            label2.topAnchor.constraint(equalTo: header2.topAnchor),
            label2.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor, constant: 16),
            
            filter.centerYAnchor.constraint(equalTo: label2.centerYAnchor),
            filter.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            bannerMedicineCollectionView.topAnchor.constraint(equalTo: header2.bottomAnchor),
            bannerMedicineCollectionView.heightAnchor.constraint(equalToConstant: 200),
            bannerMedicineCollectionView.widthAnchor.constraint(equalToConstant: uiscrollView.frame.size.width - 32),
            bannerMedicineCollectionView.centerXAnchor.constraint(equalTo: uiscrollView.centerXAnchor),
            
            medicinalProductsCollectionView.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor),
            medicinalProductsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            medicinalProductsCollectionView.topAnchor.constraint(equalTo: bannerMedicineCollectionView.bottomAnchor, constant: 10),
            medicinalProductsCollectionView.heightAnchor.constraint(equalToConstant: 300),
            medicinalProductsCollectionView.bottomAnchor.constraint(equalTo: uiscrollView.bottomAnchor, constant: -10),
            
//            header3.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor),
//            header3.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            header3.topAnchor.constraint(equalTo: medicinalProductsCollectionView.bottomAnchor, constant: 20),
//            header3.heightAnchor.constraint(equalToConstant: 30),
//            
//            label3.centerYAnchor.constraint(equalTo: header3.centerYAnchor),
//            label3.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor, constant: 16),
//            
//            allArticles.topAnchor.constraint(equalTo: header3.topAnchor),
//            allArticles.bottomAnchor.constraint(equalTo: header3.bottomAnchor),
//            allArticles.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            allArticles.widthAnchor.constraint(equalToConstant: 100),
//            
//            blogCollectionView.topAnchor.constraint(equalTo: header3.bottomAnchor, constant: 20),
//            blogCollectionView.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor),
//            blogCollectionView.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor),
//            blogCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            blogCollectionView.heightAnchor.constraint(equalToConstant: 410),
//            
//            header4.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor),
//            header4.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            header4.topAnchor.constraint(equalTo: blogCollectionView.bottomAnchor, constant: 16),
//            header4.heightAnchor.constraint(equalToConstant: 30),
//
//            button.topAnchor.constraint(equalTo: header4.topAnchor),
//            button.bottomAnchor.constraint(equalTo: header4.bottomAnchor),
//            button.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor, constant: 16),
//            button.widthAnchor.constraint(equalToConstant: 120),
//            
//            link.topAnchor.constraint(equalTo: header4.topAnchor),
//            link.bottomAnchor.constraint(equalTo: header4.bottomAnchor),
//            link.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            
//            instagram.topAnchor.constraint(equalTo: header4.topAnchor),
//            instagram.bottomAnchor.constraint(equalTo: header4.bottomAnchor),
//            instagram.trailingAnchor.constraint(equalTo: link.leadingAnchor, constant: -8),
//            
//            facebook.topAnchor.constraint(equalTo: header4.topAnchor),
//            facebook.bottomAnchor.constraint(equalTo: header4.bottomAnchor),
//            facebook.trailingAnchor.constraint(equalTo: instagram.leadingAnchor, constant: -8),
//            
//            telegram.topAnchor.constraint(equalTo: header4.topAnchor),
//            telegram.bottomAnchor.constraint(equalTo: header4.bottomAnchor),
//            telegram.trailingAnchor.constraint(equalTo: facebook.leadingAnchor, constant: -8),
//
//            label4.centerXAnchor.constraint(equalTo: button.centerXAnchor),
//            label4.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            
            
//            header5.topAnchor.constraint(equalTo: header4.bottomAnchor, constant: 35),
//            header5.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor),
//            header5.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            header5.heightAnchor.constraint(equalToConstant: 30),
//
//            label5.topAnchor.constraint(equalTo: header5.topAnchor),
//            label5.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor, constant: 16),
//
//            filterForVitamin.centerYAnchor.constraint(equalTo: label5.centerYAnchor),
//            filterForVitamin.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//
//            vitaminCollectionView.topAnchor.constraint(equalTo: header5.bottomAnchor),
//            vitaminCollectionView.heightAnchor.constraint(equalToConstant: 200),
//            vitaminCollectionView.widthAnchor.constraint(equalToConstant: uiscrollView.frame.size.width - 32),
//            vitaminCollectionView.centerXAnchor.constraint(equalTo: uiscrollView.centerXAnchor),
//
//            badsCollectionView.leadingAnchor.constraint(equalTo: uiscrollView.leadingAnchor),
//            badsCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            badsCollectionView.topAnchor.constraint(equalTo: vitaminCollectionView.bottomAnchor),
//            badsCollectionView.heightAnchor.constraint(equalToConstant: 285)
        ])
    }
    
    @objc func openTelegram() {
        let telegram = "https://t.me/salomattj"
        let telegramURL = URL(string: telegram)!
        if UIApplication.shared.canOpenURL(telegramURL) {
            UIApplication.shared.open(telegramURL)
        }
        else {
            UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/telegram-messenger/id686449807")!)
        }
    }
    
    @objc func openFacebook() {
        let facebook = "https://facebook.com/salomat.tj"
        let facebookURL = URL(string: facebook)!
        if UIApplication.shared.canOpenURL(facebookURL) {
            UIApplication.shared.open(facebookURL)
        }
        else {
            UIApplication.shared.open(URL(string: "https://apps.apple.com/ru/app/facebook/id284882215")!)
        }
    }
    
    @objc func openInstagram() {
        let instagram = "http://instagram.com/salomat.tj"
        let instagramURL = URL(string: instagram)!
        if UIApplication.shared.canOpenURL(instagramURL) {
            UIApplication.shared.open(instagramURL)
        }
        else {
            UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/instagram/id389801252")!)
            print("dnfkjsn")
        }
    }
    
    @objc func openLink() {
        let link = "http://salomat.tj"
        let linkURL = URL(string: link)!
        if UIApplication.shared.canOpenURL(linkURL) {
            UIApplication.shared.open(linkURL)
        }
        else {
            UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/instagram/id389801252")!)
            print("dnfkjsn")
        }
    }
    
    @objc func testBottomSheet() {
//        let vc = SearchBarViewController()
//        vc.modalPresentationStyle = .overCurrentContext
//        // keep false
//        // modal animation will be handled in VC itself
//        self.present(vc, animated: true)
        
        // Set any properties (in this case, don't hide the nav bar and don't show the emoji keyboard option)
        //searchController.hidesNavigationBarDuringPresentation = true
        
        // Make this class the delegate and present the search
        //navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        present(searchController, animated: true)
    }
    
    @objc func showMainCategories() {
        if #available(iOS 15.0, *) {
            let vc = CategoriesViewController()
            vc.medicine = self
            vc.category = self.categories
            let navigationController = UINavigationController(rootViewController: vc)
            if let sheet = navigationController.sheetPresentationController {
                sheet.detents = [.large(), .medium()]
            }
            self.present(navigationController, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
            let vc = CategoriesBottomSheetViewController()
            let navigationController = UINavigationController(rootViewController: vc)
            vc.medicine = self
            vc.category = categories
            navigationController.modalPresentationStyle = .custom
            present(navigationController, animated: false)
        }
    }
    
    @objc func showCategories() {
//        let vc =  CategoriesBottomSheetViewController()
        let vc = DoubleSliderViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .pageSheet
        if #available(iOS 15.0, *) {

            if let presentationController = navigationController.presentationController as? UISheetPresentationController {

                presentationController.detents =  [.medium(), .large()]
                self.present(navigationController, animated: true)
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    @objc func searchContr() {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func fetchVitamin(){
        let urlString = "/products/categories_for_main_page?user_id=\(keychain["UserID"] ?? "")"
        self.network.fetchFromApi(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.badsCollectionView.vitamin = response
                self.badsCollectionView.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    func fetchFromApi(){
        let urlString = "/products/prods_of_the_day?user_id=\(keychain["UserID"] ?? "")"
        self.network.fetchData(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.itemsCollectionView.product = response
                self.product = response
                print(response)
                self.itemsCollectionView.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    func fetchCategories(){
        let urlString = "/products/categories"
        self.network.category(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.categories = response
                print(response, "CATEGORIES")
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    func fetchData(){
        let urlString = "/products/categories_for_main_page?user_id=\(keychain["UserID"] ?? "")"
        self.network.fetchFromApi(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.medicinalProductsCollectionView.categories = response
                self.bannerMedicineCollectionView.banner = response
                self.banner = response
                self.vitaminCollectionView.banner = response
                self.medicinalProductsCollectionView.reloadData()
                self.bannerMedicineCollectionView.reloadData()
                self.vitaminCollectionView.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    func fetchBlogData(){
        let urlString = "/blogs/blog_popular?page=1"
        self.network.fetchBlogsData(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.blogCollectionView.blogs = response
                self.blogCollectionView.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    func fetchBanner(){
        let urlString = "/products/main_sliders"
        self.network.fetchBanners(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.bannersCollectionView.banners = response
                self.banners = response
                self.bannersCollectionView.reloadData()
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    @objc func action() {
        let vc = CategoriesViewController()
        if #available(iOS 15.0, *) {
            if let sheet = vc.sheetPresentationController {
                sheet.detents = [.large(), .medium()]
            }
        } else {
            // Fallback on earlier versions
        }
        present(vc, animated: true, completion: nil)
    }
}
extension MainViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let vc = SearchViewController()
        vc.searchProduct = searchBar.text!
//        searchBarView.removeFromSuperview()
//        searchBar.text = ""
        //searchController.removeFromParent()
        let navigationController = UINavigationController(rootViewController: vc)
        //self.navigationController?.pushViewController(vc, animated: true)
        
        navigationController.modalPresentationStyle = .fullScreen
        navigationController.modalTransitionStyle = .crossDissolve
        //present(navigationController, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
        searchBar.showsCancelButton = true
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
            cancelButton.isEnabled = true
           
        }
//        navigationItem.searchController = nil
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        //disable cancel button
        searchBar.setShowsCancelButton(false, animated: true)
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
            cancelButton.isEnabled = false
            
        }
    }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.showsCancelButton = true
    }
}

extension MainViewController: MedicineFromCategory {
    func update(id: String, name: String, subCat: [SubCat]?) {
        let vc = CategoriesPageViewController()
        vc.id = id
        vc.title = name
        vc.subCat = subCat
        vc.openCategories = self
        self.navigationController?.pushViewController(vc, animated: true)
        print("id of category \(id)")
    }
}
extension MainViewController: UICollectionViewDelegate, SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return MedicinesCollectionViewCell.identifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.prods_of_the_day?.count ?? 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = itemsCollectionView.dequeueReusableCell(withReuseIdentifier: MedicinesCollectionViewCell.identifier, for: indexPath) as! MedicinesCollectionViewCell
        let data = product?.prods_of_the_day?[indexPath.row]
        cell.id = data?.id ?? ""
        cell.is_favorite = ((data?.is_favorite) != nil)
        cell.titleMedicine = data?.product_name ?? ""
        cell.images = data?.product_pic ?? ""
        cell.prices = data?.product_price ?? ""
        cell.title.text = data?.product_name ?? ""
        cell.count = Int(data?.total_count_in_store ?? "") ?? 0
//        cell.cosmosView.rating = Double(data?.prod_rating_average ?? 0)
//        let string = String(data?.prod_rating_average)
//        data?.prod_rating_average.encode(to: String)
//        if let number = Int(string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) {
//            // Do something with this number
//        }
//        data?.prod_rating_average.forEach { value in
//            switch value {
//            case .int(let intValue):
//                print(intValue)
//            case .string(let stringValue):
//                print(stringValue)
//            }
//        }
     
                switch data?.prod_rating_average {
                case .int(let intValue):
                    cell.cosmosView.rating = Double(intValue)
                case .string(let stringValue):
                    cell.cosmosView.rating = Double(stringValue) ?? 0
                default: break
                    
                }
        let url = "http://salomat.tj/upload_product/"
        let completeURL = url + (data?.product_pic ?? "")
        cell.configureConstraints()
        if data?.is_favorite == false {
            cell.button.setImage(UIImage(named: "favorite"), for: .normal)
            cell.isFav = false
            }
        else if data?.is_favorite == true{
            cell.button.setImage(UIImage(named: "heart"), for: .normal)
            cell.isFav = true
            }
        cell.reloadData = self
        cell.image.kf.indicatorType = .activity
        cell.image.kf.setImage(with: URL(string: completeURL))
        cell.titleMedicine = data?.product_name ?? ""
        cell.prices = data?.product_price ?? ""
        cell.images = data?.product_pic ?? ""
        let fetchRequest: NSFetchRequest <Basket> = Basket.fetchRequest()
        commitPredicate = NSPredicate(format: "id == %@", data?.id ?? "")
        fetchRequest.predicate = commitPredicate
        do {
            let data = try context.fetch(fetchRequest)
            for i in data {
                if i.id == self.product?.prods_of_the_day?[indexPath.row].id ?? "" {
                    cell.cartButton.backgroundColor = .lightGray
                    cell.cartButton.setTitle("Убрать из корзины", for: .normal)
                    cell.contentView.layer.borderColor = UIColor.black.cgColor
                }
                else if i.id == nil{
                    cell.cartButton.backgroundColor = .black
                    cell.contentView.layer.borderColor = UIColor.gray.cgColor
                    cell.cartButton.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
                    cell.cartButton.setTitle("В корзину", for: .normal)
                }
            }
        }
        catch {
            print("Error\(error)")
        }
//        let fetch_request: NSFetchRequest <DataModel> = DataModel.fetchRequest()
//        predicate = NSPredicate(format: "id == %@", self.product?.prods_of_the_day?[indexPath.row].id ?? "")
//        fetch_request.predicate = predicate
//        do {
//            let favoriteData = try contextData.fetch(fetch_request)
//            for i in favoriteData {
//                if i.id == self.product?.prods_of_the_day?[indexPath.row].id ?? "" {
//                    cell.button.setImage(UIImage(named: "favorite 1"), for: .normal)
//                }
//                else if i.id == nil{
//                    cell.button.setImage(UIImage(named: "favorite"), for: .normal)
//                }
//            }
//        }
//        catch {
//            print("Error\(error)")
//        }
        cell.price.text = (data?.product_price) ?? "" + " сом."
        cell.is_favorite = ((data?.is_favorite) != nil)
        cell.id = data?.id ?? ""
        cell.hideAnimation()
//        if (product?.prods_of_the_day?.count ?? 0) > 0 {
//
//            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//                cell.hideAnimation()
//            }
//        }
        return cell
    }
    
    
    
    @objc func empty() {
        print("don't work")
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width / 2.1 * 0.92, height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = AboutProductViewController()
        vc.title = product?.prods_of_the_day?[indexPath.row].product_name ?? ""
        vc.id = product?.prods_of_the_day?[indexPath.row].id ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension MainViewController: ReloadData {
    func update() {
        fetchFromApi()
//        self.reloadData()
    }
}
extension MainViewController: OpenCategories {
    func openCategories() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // your code here
//            let vc = DoubleSliderViewController()
//            let navigationController = UINavigationController(rootViewController: vc)
            let vc = CategoriesViewController()
            vc.medicine = self
            vc.category = self.categories
            let navigationController = UINavigationController(rootViewController: vc)
            if #available(iOS 15.0, *) {
                if let sheet = navigationController.sheetPresentationController {
                    sheet.detents = [.large(), .medium()]
                }
            } else {
                // Fallback on earlier versions
            }
            self.present(navigationController, animated: true, completion: nil)
        }
//            navigationController.modalPresentationStyle = .custom
//            self.present(navigationController, animated: false)
    }
}







