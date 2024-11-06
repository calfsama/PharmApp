//
//  DoubleSliderViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 15/04/23.
//

import UIKit
import DoubleSlider

class DoubleSliderViewController: BottomSheetViewController {
    var doubleSlider = DoubleSlider()
    var network = NetworkService()
    var popularCondition: Bool = true
    var notPopularCondition: Bool = false
    var labels: [String] = []
    var kind: String = ""
    var min: Int = 0
    var max: Int = 200
    var rating: String = ""
    
    lazy var minPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var maxPrice: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var uiview: UIView = {
        let uiview = UIView()
        uiview.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        uiview.layer.cornerRadius = 4
        uiview.translatesAutoresizingMaskIntoConstraints = false
        return uiview
    }()
    
    lazy var price: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var raiting: UILabel = {
        let label = UILabel()
        label.text = "Рейтинг"
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var popular: UILabel = {
        let label = UILabel()
        label.text = "популярное"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var notPopular: UILabel = {
        let label = UILabel()
        label.text = "непопулярное"
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var showButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.setTitle("Показать", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.layer.cornerRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var notPopularButton: UIButton = {
        let button =  UIButton()
        button.setImage(UIImage(named: "Radiobutton 1"), for: .normal)
        button.addTarget(self, action: #selector(actionForNotPopularButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var popularButton: UIButton = {
        let button =  UIButton()
        button.setImage(UIImage(named: "Radiobutton 1"), for: .normal)
        button.addTarget(self, action: #selector(actionForPopularButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var data: DataFilter?

    @objc func tapped() {
        self.dismiss(animated: true)
        data?.data(minimumPrice: "\(doubleSlider.lowerValueStepIndex)", maximumPrice: "\(doubleSlider.upperValueStepIndex)", kind: kind, raiting: rating)
        //filterData?.updateData(minPrice: "\(slider.values.minimum)", maxPrice: "\(slider.values.maximum)")
        self.dismiss(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        makeLabels()
        view.backgroundColor = .white
        setupConstraints()
        doubleSlider.translatesAutoresizingMaskIntoConstraints = false
        doubleSlider.labelDelegate = self
        doubleSlider.numberOfSteps = labels.count
        doubleSlider.smoothStepping = true
        doubleSlider.labelsAreHidden = true
        doubleSlider.lowerValueStepIndex = min
        doubleSlider.upperValueStepIndex = max
        doubleSlider.trackHighlightTintColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1)
        doubleSlider.thumbTintColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1)
        maxPrice.text = "\(doubleSlider.upperValueStepIndex + 1) c."
        minPrice.text = "\(doubleSlider.lowerValueStepIndex + 1) c."
        doubleSlider.addTarget(self, action: #selector(didChangeSliderValue), for: .valueChanged)
        if rating == "Популярное" {
            popularButton.setImage(UIImage(named: "Radiobutton 2"), for: .normal)
        }
        else if rating == "Непопулярное" {
            notPopularButton.setImage(UIImage(named: "Radiobutton 2"), for: .normal)
        }
    }
    
    @objc private func didChangeSliderValue() {
        minPrice.text = "\(Int(doubleSlider.lowerValueStepIndex) + 1) c."
        maxPrice.text = "\(Int(doubleSlider.upperValueStepIndex) + 1) c."
    }
    
    @objc func actionForPopularButton() {
        if popularCondition == false {
            popularCondition = true
            notPopularCondition = false
            notPopularButton.setImage(UIImage(named: "Radiobutton 1"), for: .normal)
            popularButton.setImage(UIImage(named: "Radiobutton 2"), for: .normal)
            print("Find popular")
            rating = "Популярное"
            kind = "pr"
        }
        else if popularCondition == true {
            popularCondition = false
            popularButton.setImage(UIImage(named: "Radiobutton 1"), for: .normal)
        }
    }
    
    @objc func actionForNotPopularButton() {
        if notPopularCondition == false {
            notPopularCondition = true
            popularCondition = false
            popularButton.setImage(UIImage(named: "Radiobutton 1"), for: .normal)
            notPopularButton.setImage(UIImage(named: "Radiobutton 2"), for: .normal)
            print("Find not popular")
            rating = "Непопулярное"
            kind = ""
        }
        else if notPopularCondition == true {
            notPopularCondition = false
            notPopularButton.setImage(UIImage(named: "Radiobutton 1"), for: .normal)
        }
    }
    
    func setupConstraints() {
        view.addSubview(price)
        view.addSubview(minPrice)
        view.addSubview(maxPrice)
        view.addSubview(doubleSlider)
        view.addSubview(raiting)
        view.addSubview(popularButton)
        view.addSubview(popular)
        view.addSubview(notPopularButton)
        view.addSubview(notPopular)
        view.addSubview(showButton)
        
        // Set static constraints
        NSLayoutConstraint.activate([
            
            price.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            price.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            doubleSlider.topAnchor.constraint(equalTo: price.bottomAnchor, constant: 16),
            doubleSlider.heightAnchor.constraint(equalToConstant: 40),
            doubleSlider.widthAnchor.constraint(equalToConstant: view.frame.size.width - 32),
            doubleSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            minPrice.topAnchor.constraint(equalTo: doubleSlider.bottomAnchor, constant: 5),
            minPrice.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            maxPrice.topAnchor.constraint(equalTo: doubleSlider.bottomAnchor, constant: 5),
            maxPrice.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            raiting.topAnchor.constraint(equalTo: minPrice.bottomAnchor, constant: 16),
            raiting.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            popularButton.topAnchor.constraint(equalTo: raiting.bottomAnchor, constant: 20),
            popularButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            popularButton.heightAnchor.constraint(equalToConstant: 20),
            popularButton.widthAnchor.constraint(equalToConstant: 20),
            
            popular.leadingAnchor.constraint(equalTo: popularButton.trailingAnchor, constant: 5),
            popular.topAnchor.constraint(equalTo: raiting.bottomAnchor, constant: 20),
            
            notPopularButton.topAnchor.constraint(equalTo: raiting.bottomAnchor, constant: 20),
            notPopularButton.leadingAnchor.constraint(equalTo: popular.trailingAnchor, constant: 25),
            notPopularButton.heightAnchor.constraint(equalToConstant: 20),
            notPopularButton.widthAnchor.constraint(equalToConstant: 20),
            
            notPopular.topAnchor.constraint(equalTo: raiting.bottomAnchor, constant: 20),
            notPopular.leadingAnchor.constraint(equalTo: notPopularButton.trailingAnchor, constant: 5),
            
            showButton.topAnchor.constraint(equalTo: notPopular.bottomAnchor, constant: 40),
            showButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            showButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            showButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    private func makeLabels() {
        for num in stride(from: 1, to: 201, by: 1) {
            labels.append("\(num)")
        }
    }
//
//    private func setupDoubleSlider() {
//
//
//    }
}

//extension DoubleSliderViewController: DoubleSliderEditingDidEndDelegate {
//    func editingDidEnd(for doubleSlider: DoubleSlider) {
//        print("Lower Step Index: \(doubleSlider.lowerValueStepIndex) Upper Step Index: \(doubleSlider.upperValueStepIndex)")
//    }
//}

extension DoubleSliderViewController: DoubleSliderLabelDelegate {
    func labelForStep(at index: Int) -> String? {
        return labels.item(at: index)
    }
}
