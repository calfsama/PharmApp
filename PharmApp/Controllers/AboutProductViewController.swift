//
//  AboutProductViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 20/01/23.
//

import UIKit
import CoreData
import Cosmos
import Kingfisher
import KeychainAccess

@objc protocol SendFeedback {
    @objc func feedback(promocode: String)
}

class AboutProductViewController: UIViewController {
    var similarProducts: SimilarProductsCollectionView!
    var reviewCollectionView = ReviewCollectionView()
    var dataModel = [DataModel]()
    var dataBasket = [Basket]()
    var id: String = ""
    var is_favorite: Bool = false
    var titleMedicine: String = ""
    var images: String = ""
    var prices: String = ""
    var commitPredicate: NSPredicate?
    var alert: UIAlertController!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var productShow: ProductsShow?
    var network = NetworkService()
    var spinner = UIActivityIndicatorView()
    let keychain = Keychain(service: "tj.info.Salomat")
    var conditionAnalog: Bool = true
    
    lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.frame = view.bounds
        scroll.showsVerticalScrollIndicator = false
        scroll.contentSize = CGSize(width: view.frame.size.width, height: 1100)
        scroll.backgroundColor = .white
        return scroll
    }()
    
    lazy var productDesc: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.text = "Антацидный препарат, представляющий собой сбалансированную комбинацию алгелдрата (алюминия гидроксида) и магния гидроксида..."
        label.numberOfLines = 5
        label.alpha = 0.9
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var uiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.235, green: 0.902, blue: 0.51, alpha: 1)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var uiVieww: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.929, green: 0.929, blue: 1, alpha: 1)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var uiView1: UIView = {
        let uiView = UIView()
        uiView.layer.cornerRadius = 4
        uiView.backgroundColor = UIColor(red: 0.235, green: 0.902, blue: 0.51, alpha: 1)
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var cosmosView: CosmosView = {
        let cosmos = CosmosView()
        cosmos.rating = 0.0
        cosmos.settings.updateOnTouch = false
        cosmos.settings.fillMode = .precise
        cosmos.settings.starMargin = 4.5
        cosmos.translatesAutoresizingMaskIntoConstraints = false
        return cosmos
    }()
    
    lazy var delivery: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "Important info 1")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var favorite: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(saveToFavorites), for: .touchUpInside)
        button.setImage(UIImage(named: "favorite"), for: .normal)
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
        note.font = UIFont.systemFont(ofSize: 13, weight: .regular)
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
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        button.addTarget(self, action: #selector(saveInBasket), for: .touchUpInside)
        button.setTitle("В корзину", for: .normal)
        button.backgroundColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var inStock: UILabel = {
        let inStock = UILabel()
        inStock.textColor = UIColor(red: 0.235, green: 0.902, blue: 0.51, alpha: 1)
        inStock.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        inStock.translatesAutoresizingMaskIntoConstraints = false
        return inStock
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont(name: "Noto Sans Kannada Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var label2: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont(name: "Noto Sans Kannada Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var label3: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont(name: "Noto Sans Kannada Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var label4: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont(name: "Noto Sans Kannada Regular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var label5: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var label6: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var label7: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var instruction: UIButton = {
        let button = UIButton()
        button.setTitle("Инструкция", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Noto Sans Kannada Regular", size: 16)
        button.setTitleColor( UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(instructionAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var analog: UIButton = {
        let button = UIButton()
        button.setTitle("Аналог", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Noto Sans Kannada Regular", size: 16)
        button.setTitleColor(UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(analogAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var feedback: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont(name: "Noto Sans Kannada Regular", size: 16)
        button.setTitleColor(UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(reviewAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var more: UIButton = {
        let button = UIButton()
        button.setTitle("еще...", for: .normal)
        button.titleLabel?.font = UIFont(name: "Noto Sans Kannada Regular", size: 14)
        button.setTitleColor(UIColor.gray, for: .normal)
        button.addTarget(self, action: #selector(moreAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var uiView2: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .white
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var uiView3: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .white
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scroll)
        similarProducts = SimilarProductsCollectionView(nav: self.navigationController!)
        spinner.color = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        spinner.center = view.center
        navigationController?.navigationBar.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        scroll.addSubview(spinner)
        spinner.startAnimating()
        buttonState()
        print(id)
        print(keychain["UserID"])
        fetchBanner()
    }
    
    @objc func moreAction() {
        if productDesc.numberOfLines > 0 {
            productDesc.numberOfLines = 0
            more.setTitle("cкрыть", for: .normal)
        }
        else if productDesc.numberOfLines == 0 {
            productDesc.numberOfLines = 5
            more.setTitle("еще...", for: .normal)
        }
    }
    
    func fetchBanner(){
        let urlString = "http://salomat.tj/products/show?product_id=\(id)&user_id=\(keychain["UserID"] ?? "")"
        let host = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        self.network.productShow(urlString: urlString) { [weak self] (result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                self.productShow = response
                self.reviewCollectionView.id = self.id
                self.reviewCollectionView.productShow = response
                self.similarProducts.products = response
//                self.productDesc.attributedText = self.productShow?.product?.product_about?.html2Attributed
                self.productDesc.attributedText = getAttributedDescriptionText(for: self.productShow?.product?.product_about ?? "", fontDescription: "Noto Sans Kannada", fontSize: 16)
                self.id = self.id
                let url = "http://salomat.tj/upload_product/"
                let completeURL = url + (self.productShow?.product?.product_pic ?? "")
                self.image.kf.setImage(with: URL(string: completeURL))
                self.note.text = "Внешний вид товара может отличаться от изображённого на фотографии"
                self.feedback.setTitle("Отзывы (\(self.productShow?.comments?.count ?? 0))", for: .normal)
                if Int(self.productShow?.product?.total_count_in_store ?? "") ?? 0 <= 0 {
                    self.inStock.text = "Нет в наличии"
                    self.inStock.textColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
                }
                else {
                    self.inStock.text = "В наличии"
                }
                
                if self.productShow?.product?.is_favorite == true {
                    self.favorite.setImage(UIImage(named: "heart"), for: .normal)
                }
                else {
                    self.favorite.setImage(UIImage(named: "favorite"), for: .normal)
                }
                switch productShow?.product?.prod_rating_average {
                case .int(let intValue):
                    cosmosView.rating = Double(intValue)
                case .string(let stringValue):
                    cosmosView.rating = Double(stringValue) ?? 0
                default: break
                    
                }
                self.label.text = "\(self.productShow?.product?.product_type ?? "") ПРЕПАРАТ"
                self.label2.text = "Действующее вещество (МНН):"
                self.label3.text = "Производитель:"
                self.label4.text = "Категория:"
                let v = self.productShow?.product?.prod_rating_average
                print((self.productShow?.product?.prod_rating_average)!, "self.productShow?.product?.prod_rating_average")
                
//                self.cosmosView.rating = Double((self.productShow?.product?.prod_rating_average)!) ?? 0
                self.price.text = self.productShow?.product?.product_price ?? ""
                self.label5.text = self.productShow?.product?.product_form?.form_name ?? ""
                self.label6.text = self.productShow?.product?.product_brand?.brand_name ?? ""
                self.label7.text = self.productShow?.product?.categories?[0].category_name ?? ""
                self.configureConstraints()
                self.spinner.stopAnimating()
                self.reviewCollectionView.reloadData()
                print(result)
                print(urlString, "urlString")
            case .failure(let error):
                print("error", error)
                print(urlString, "urlString")
            }
        }
    }
    
    @objc func instructionAction() {
        conditionAnalog = true
        uiView3.removeFromSuperview()
        uiView2.removeFromSuperview()
        productDesc.textColor = .black
        productDesc.numberOfLines = 5
        more.setTitleColor(UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1), for: .normal)
        analog.setTitleColor(UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1), for: .normal)
        feedback.setTitleColor(UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1), for: .normal)
        instruction.setTitleColor( UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1), for: .normal)
        uiView1.removeFromSuperview()
        scroll.addSubview(uiVieww)
        scroll.addSubview(uiView1)
//        uiView1.comingFromRight4(containerView: uiView1.superview!, x: analog.frame.origin.x)
        uiView1.comingFromRight5(containerView: uiView1.superview!)
//        uiView1.comingFromRight2(containerView: uiView1.superview!)
        
        NSLayoutConstraint.activate([
            uiVieww.centerYAnchor.constraint(equalTo: uiView1.centerYAnchor),
            uiVieww.leadingAnchor.constraint(equalTo: instruction.leadingAnchor),
            uiVieww.trailingAnchor.constraint(equalTo: feedback.trailingAnchor),
            uiVieww.heightAnchor.constraint(equalToConstant: 2),
            
            uiView1.topAnchor.constraint(equalTo: instruction.bottomAnchor, constant: 3),
            uiView1.leadingAnchor.constraint(equalTo: instruction.leadingAnchor),
            uiView1.trailingAnchor.constraint(equalTo: instruction.trailingAnchor),
            uiView1.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
    @objc func analogAction() {
        uiView1.removeFromSuperview()
        if conditionAnalog == true {
            scroll.addSubview(uiVieww)
            scroll.addSubview(uiView2)
            scroll.addSubview(uiView1)
            uiView2.addSubview(similarProducts)
            uiView1.comingFromRight6(containerView: uiView1.superview!)
            uiView2.comingFromRight2(containerView: uiView2.superview!)
        }
        else if conditionAnalog == false {
            conditionAnalog = true
            scroll.addSubview(uiVieww)
            scroll.addSubview(uiView2)
            scroll.addSubview(uiView1)
            uiView2.addSubview(similarProducts)
            uiView1.comingFromRight5(containerView: uiView1.superview!)
            uiView2.comingFromRight3(containerView: uiView2.superview!)
        }
        
        instruction.setTitleColor(UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1), for: .normal)
        feedback.setTitleColor(UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1), for: .normal)
        analog.setTitleColor( UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1), for: .normal)
        
        productDesc.numberOfLines = 23
        productDesc.textColor = .white
        uiView3.removeFromSuperview()
        more.setTitleColor(.white, for: .normal)
        
        NSLayoutConstraint.activate([
            uiView2.topAnchor.constraint(equalTo: instruction.bottomAnchor, constant: 10),
            uiView2.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            uiView2.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            uiView2.heightAnchor.constraint(equalToConstant: 320),
            uiView2.bottomAnchor.constraint(equalTo: delivery.topAnchor),
            
            similarProducts.topAnchor.constraint(equalTo: uiView2.topAnchor),
            similarProducts.leadingAnchor.constraint(equalTo: uiView2.leadingAnchor),
            similarProducts.trailingAnchor.constraint(equalTo: uiView2.trailingAnchor),
            similarProducts.bottomAnchor.constraint(equalTo: uiView2.bottomAnchor),
            
            uiVieww.centerYAnchor.constraint(equalTo: uiView1.centerYAnchor),
            uiVieww.leadingAnchor.constraint(equalTo: instruction.leadingAnchor),
            uiVieww.trailingAnchor.constraint(equalTo: feedback.trailingAnchor),
            uiVieww.heightAnchor.constraint(equalToConstant: 2),
            
            uiView1.topAnchor.constraint(equalTo: analog.bottomAnchor, constant: 3),
            uiView1.leadingAnchor.constraint(equalTo: analog.leadingAnchor),
            uiView1.trailingAnchor.constraint(equalTo: analog.trailingAnchor),
            uiView1.heightAnchor.constraint(equalToConstant: 4)
        ])
    }
    
    @objc func reviewAction() {
        conditionAnalog = false
        uiView1.removeFromSuperview()
        
        scroll.addSubview(uiVieww)
        scroll.addSubview(uiView1)
        uiView1.comingFromRight6(containerView: uiView1.superview!)
        instruction.setTitleColor(UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1), for: .normal)
        analog.setTitleColor(UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1), for: .normal)
        feedback.setTitleColor( UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1), for: .normal)
        scroll.addSubview(uiView3)
        uiView3.addSubview(reviewCollectionView)
        uiView3.comingFromRight2(containerView: uiView3.superview!)
        productDesc.numberOfLines = 23
        productDesc.textColor = .white
        similarProducts.removeFromSuperview()
        
        NSLayoutConstraint.activate([
            uiView3.topAnchor.constraint(equalTo: instruction.bottomAnchor, constant: 20),
            uiView3.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            uiView3.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            uiView3.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            
            reviewCollectionView.topAnchor.constraint(equalTo: uiView3.topAnchor),
            reviewCollectionView.leadingAnchor.constraint(equalTo: uiView3.leadingAnchor),
            reviewCollectionView.trailingAnchor.constraint(equalTo: uiView3.trailingAnchor),
            reviewCollectionView.bottomAnchor.constraint(equalTo: scroll.bottomAnchor),
            
            delivery.bottomAnchor.constraint(equalTo: reviewCollectionView.bottomAnchor),
            
            uiVieww.centerYAnchor.constraint(equalTo: uiView1.centerYAnchor),
            uiVieww.leadingAnchor.constraint(equalTo: instruction.leadingAnchor),
            uiVieww.trailingAnchor.constraint(equalTo: feedback.trailingAnchor),
            uiVieww.heightAnchor.constraint(equalToConstant: 2),
            
            uiView1.topAnchor.constraint(equalTo: feedback.bottomAnchor, constant: 3),
            uiView1.leadingAnchor.constraint(equalTo: feedback.leadingAnchor),
            uiView1.trailingAnchor.constraint(equalTo: feedback.trailingAnchor),
            uiView1.heightAnchor.constraint(equalToConstant: 4),
        ])
    }
    
    func configureConstraints() {
        scroll.addSubview(image)
        scroll.addSubview(medicineName)
        scroll.addSubview(note)
        scroll.addSubview(cosmosView)
        scroll.addSubview(price)
        scroll.addSubview(favorite)
        scroll.addSubview(buttonSave)
        scroll.addSubview(inStock)
        scroll.addSubview(label)
        scroll.addSubview(label2)
        scroll.addSubview(label3)
        scroll.addSubview(label4)
        scroll.addSubview(label5)
        scroll.addSubview(label6)
        scroll.addSubview(label7)
        scroll.addSubview(uiVieww)
        scroll.addSubview(uiView1)
        scroll.addSubview(instruction)
        scroll.addSubview(analog)
        scroll.addSubview(feedback)
        scroll.addSubview(productDesc)
        scroll.addSubview(delivery)
        scroll.addSubview(more)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 10),
            image.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            image.widthAnchor.constraint(equalToConstant: 360),
            image.heightAnchor.constraint(equalToConstant: 360),
            
            favorite.topAnchor.constraint(equalTo: image.topAnchor),
            favorite.trailingAnchor.constraint(equalTo: image.trailingAnchor, constant: -30),
            favorite.heightAnchor.constraint(equalToConstant: 30),
            favorite.widthAnchor.constraint(equalToConstant: 30),
            
            medicineName.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 16),
            medicineName.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            medicineName.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            note.topAnchor.constraint(equalTo: medicineName.bottomAnchor, constant: 16),
            note.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            note.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            
            cosmosView.topAnchor.constraint(equalTo: note.bottomAnchor, constant: 20),
            cosmosView.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            cosmosView.heightAnchor.constraint(equalToConstant: 40),
            cosmosView.widthAnchor.constraint(equalToConstant: 200),
            
            price.topAnchor.constraint(equalTo: cosmosView.bottomAnchor, constant: 20),
            price.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            
            buttonSave.topAnchor.constraint(equalTo: cosmosView.bottomAnchor, constant: 11),
            buttonSave.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            buttonSave.widthAnchor.constraint(equalToConstant: 170),
            buttonSave.heightAnchor.constraint(equalToConstant: 45),
            
            inStock.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 16),
            inStock.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            
            label.topAnchor.constraint(equalTo: inStock.bottomAnchor, constant: 12),
            label.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            
            label2.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            label2.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            
            label3.topAnchor.constraint(equalTo: label2.bottomAnchor, constant: 3),
            label3.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            
            label4.topAnchor.constraint(equalTo: label3.bottomAnchor, constant: 3),
            label4.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            
            label5.centerYAnchor.constraint(equalTo: label2.centerYAnchor),
            label5.leadingAnchor.constraint(equalTo: label2.trailingAnchor, constant: 3),
            
            label6.centerYAnchor.constraint(equalTo: label3.centerYAnchor),
            label6.leadingAnchor.constraint(equalTo: label3.trailingAnchor, constant: 3),
            
            label7.centerYAnchor.constraint(equalTo: label4.centerYAnchor),
            label7.leadingAnchor.constraint(equalTo: label4.trailingAnchor, constant: 3),
            
            instruction.topAnchor.constraint(equalTo: label7.bottomAnchor, constant: 20),
            instruction.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 12),
            instruction.heightAnchor.constraint(equalToConstant: 40),
            instruction.widthAnchor.constraint(equalToConstant: 100),
            
            uiVieww.centerYAnchor.constraint(equalTo: uiView1.centerYAnchor),
            uiVieww.leadingAnchor.constraint(equalTo: instruction.leadingAnchor),
            uiVieww.trailingAnchor.constraint(equalTo: feedback.trailingAnchor),
            uiVieww.heightAnchor.constraint(equalToConstant: 2),
            
            uiView1.topAnchor.constraint(equalTo: instruction.bottomAnchor, constant: 3),
            uiView1.leadingAnchor.constraint(equalTo: instruction.leadingAnchor),
            uiView1.trailingAnchor.constraint(equalTo: instruction.trailingAnchor),
            uiView1.heightAnchor.constraint(equalToConstant: 4),
    
            analog.topAnchor.constraint(equalTo: label7.bottomAnchor, constant: 20),
            analog.centerXAnchor.constraint(equalTo: scroll.centerXAnchor),
            analog.heightAnchor.constraint(equalToConstant: 40),
            analog.widthAnchor.constraint(equalToConstant: 100),
            
            feedback.topAnchor.constraint(equalTo: label7.bottomAnchor, constant: 20),
            feedback.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            feedback.heightAnchor.constraint(equalToConstant: 40),
            feedback.widthAnchor.constraint(equalToConstant: 100),
            
            productDesc.topAnchor.constraint(equalTo: instruction.bottomAnchor, constant: 20),
            productDesc.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 16),
            productDesc.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            productDesc.bottomAnchor.constraint(equalTo: delivery.topAnchor, constant: -25),
            
            more.topAnchor.constraint(equalTo: productDesc.bottomAnchor, constant: -13),
            more.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 15),
            
            // delivery.topAnchor.constraint(equalTo: productDesc.bottomAnchor, constant: 20),
            delivery.leadingAnchor.constraint(equalTo: scroll.leadingAnchor),
            delivery.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            delivery.heightAnchor.constraint(equalToConstant: 280),
            delivery.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -10)
        ])
    }
    
    
    func addFavorites() {
        guard let url = URL(string: "http://salomat.tj/favorites") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "user_id": keychain["UserID"] ?? "",
            "product_id": id
        ]
        request.httpBody = parameters.percentEncoded()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
                    
            else {
                //check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print(json)
            }
            catch {
                print(error)
            }
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    self.fetchBanner()
                }
            }
            else {
                print("error")
            }
            guard (200 ... 299) ~= response.statusCode else {
                //check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
        }
        task.resume()
    }
    
    func deleteFavorites() {
        guard let url = URL(string: "http://salomat.tj/favorites/delete") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "user_id": keychain["UserID"] ?? "",
            "product_id": id
        ]
        request.httpBody = parameters.percentEncoded()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
                    
            else {
                //check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print(json)
            }
            catch {
                print(error)
            }
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    self.fetchBanner()
                }
            }
            else {
                print("error")
            }
            guard (200 ... 299) ~= response.statusCode else {
                //check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
        }
        task.resume()
    }
    
    
    func showAlert(message: String) {
        self.alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        self.present(self.alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
    }
    
    @objc func dismissAlert(){
        // Dismiss the alert from here
        self.alert.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveToFavorites() {
        if (keychain["UserID"] ?? "") == "" {
            self.showAlert(message: "Для добавления товаров авторизуйтесь")
            print("please log in")
        } else {
            if self.productShow?.product?.is_favorite == true {
                self.favorite.setImage(UIImage(named: "favorite"), for: .normal)
                print("delete")
                deleteFavorites()
                
            }
            else {
                self.favorite.setImage(UIImage(named: "heart"), for: .normal)
                print("save")
                addFavorites()
            }
        }
    }
    
    func saveMedicine() {
        let data = DataModel(context: self.context)
        data.id = id
        data.title = productShow?.product?.product_name ?? ""
        data.price = productShow?.product?.product_price ?? ""
        data.image = productShow?.product?.product_pic ?? ""
        data.is_favorite = is_favorite
        self.dataModel.append(data)
        do {
            try context.save()
        }catch {
            print("Error saving context \(error)")
        }
    }
    
    func deleteMedicine() {
        let object: NSFetchRequest <DataModel> = DataModel.fetchRequest()
        object.predicate = commitPredicate
        commitPredicate = NSPredicate(format: "title == %@", title!)
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
    
    func buttonState() {
        let fetchRequest: NSFetchRequest <Basket> = Basket.fetchRequest()
        fetchRequest.predicate = commitPredicate
        commitPredicate = NSPredicate(format: "id == %@", id)
        do {
            let data = try context.fetch(fetchRequest)
            for i in data {
                if i.id == id {
                    //print("\(i.title) and \(title)")
                    buttonSave.backgroundColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
                    buttonSave.setTitle("Убрать из корзины", for: .normal)
                }
                else if i.id == nil{
                    buttonSave.backgroundColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
                    buttonSave.setTitle("В корзину", for: .normal)
                }
            }
        }
        catch {
            print("Error\(error)")
        }
    }
    
    @objc func buttonAction() {
        let fetchRequest: NSFetchRequest <DataModel> = DataModel.fetchRequest()
        fetchRequest.predicate = commitPredicate
        commitPredicate = NSPredicate(format: "title == %@", title!)
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
        data.title = productShow?.product?.product_name ?? ""
        data.price = productShow?.product?.product_price ?? ""
        data.image = productShow?.product?.product_pic ?? ""
        data.amount = "1"
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
        if Int(self.productShow?.product?.total_count_in_store ?? "") ?? 0 <= 0 {
            self.showAlert(message: "Нет в наличии")
        }
        else {
            let fetchRequest: NSFetchRequest <Basket> = Basket.fetchRequest()
            fetchRequest.predicate = commitPredicate
            commitPredicate = NSPredicate(format: "title == %@", productShow?.product?.product_name ?? "")
            do{
                let data = try context.fetch(fetchRequest).first
                if data == nil && data?.title != productShow?.product?.product_name ?? "" {
                    buttonSave.backgroundColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
                    buttonSave.setTitle("Убрать из корзины", for: .normal)
                    print("\(data?.title) and \(productShow?.product?.product_name ?? "")")
                    print("save")
                    saveMedicineInBasket()
                }
                else if data?.title == productShow?.product?.product_name ?? "" {
                    buttonSave.backgroundColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
                    buttonSave.setTitle("В корзину", for: .normal)
                    print("\(data?.title) and \(productShow?.product?.product_name ?? "")")
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
    
    func getAttributedDescriptionText(for descriptionString: String, fontDescription: String, fontSize: Int) -> NSAttributedString? {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1.0
//        paragraphStyle.alignment = .center
        paragraphStyle.minimumLineHeight = 18.0

        let attributedString = NSMutableAttributedString()
        let splits = descriptionString.components(separatedBy: "\n")
        _ = splits.map { string in
            let modifiedFont = String(format:"<span style=\"font-family: '\(fontDescription)'; font-size: \(fontSize)\">%@</span>", string)
            let data = modifiedFont.data(using: String.Encoding.unicode, allowLossyConversion: true)
            let attr = try? NSMutableAttributedString(
                data: data ?? Data(),
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            attributedString.append(attr ?? NSMutableAttributedString())
            if string != splits.last {
                attributedString.append(NSAttributedString(string: "\n"))
            }
        }
        attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        return attributedString
    }
}
extension UIView {
    func comingFromRight(containerView: UIView) {
        let offset = CGPoint(x: containerView.frame.maxX, y: 0)
        let x: CGFloat = 0, y: CGFloat = 0
        self.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        self.isHidden = false
        UIView.animate(
            withDuration: 1, delay: 0, usingSpringWithDamping: 0.47, initialSpringVelocity: 3,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
            })
    }
    
    func comingFromRight2(containerView: UIView) {
        let offset = CGPoint(x: containerView.frame.maxX, y: 0)
        let x: CGFloat = 0, y: CGFloat = 0
        self.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        self.isHidden = false
        UIView.animate(
            withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
            })
    }
    
    func comingFromRight6(containerView: UIView) {
        let offset = CGPoint(x: 200, y: 0)
        let x: CGFloat = 400, y: CGFloat = 0
        self.transform = CGAffineTransform(translationX: offset.x - x, y: offset.y + y)
        self.isHidden = false
        UIView.animate(
            withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
            })
    }
    
    func comingFromRight3(containerView: UIView) {
        let offset = CGPoint(x: 15, y: 0)
        let x: CGFloat = 700, y: CGFloat = 0
        self.transform = CGAffineTransform(translationX: offset.x - x, y: offset.y + y)
        self.isHidden = false
        UIView.animate(
            withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
            })
    }
    
    func comingFromRight4(containerView: UIView, x: CGFloat) {
        let offset = CGPoint(x: 15, y: 0)
        let x = x, y: CGFloat = 0
        self.transform = CGAffineTransform(translationX: offset.x - x, y: offset.y + y)
        self.isHidden = false
        UIView.animate(
            withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
            })
    }
    
    func comingFromRight5(containerView: UIView) {
        let offset = CGPoint(x: containerView.frame.maxX, y: 0)
        let x: CGFloat = -200, y: CGFloat = 0
        self.transform = CGAffineTransform(translationX: offset.x + x, y: offset.y + y)
        self.isHidden = false
        UIView.animate(
            withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 2,
            options: .curveEaseOut, animations: {
                self.transform = .identity
                self.alpha = 1
            })
    }  
}
//extension AboutProductViewController: SendFeedback {
//    
//}
