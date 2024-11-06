//
//  ReviewCollectionReusableView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 24/11/22.
//

import UIKit
import Cosmos
import TinyConstraints

class ReviewCollectionReusableView: UICollectionReusableView {
    static let identifier = "ReviewCollectionReusableView"
    var productShow: ProductsShow?
    var id: String = ""
    var idi: String = ""
    var alert: UIAlertController!
    var controller = AboutProductViewController()
    
    lazy var uiView2: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = .white
        uiView.layer.borderColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1).cgColor
        uiView.layer.borderWidth = 0.5
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var sentReview: UILabel = {
        let label = UILabel()
        label.text = "Отзыв отправлен"
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var leaveReview: UILabel = {
        let label = UILabel()
        label.text = "Оставьте свой отзыв"
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var yourMark: UILabel = {
        let label = UILabel()
        label.text = "Ваша оценка"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cosmosView: CosmosView = {
        let cosmos = CosmosView()
        cosmos.rating = 0.0
        cosmos.settings.fillMode = .precise
        cosmos.translatesAutoresizingMaskIntoConstraints = false
        return cosmos
    }()
    
    lazy var commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ваш отзыв"
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Ваше имя"
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var share: UIButton = {
        let button = UIButton()
        button.setTitle("Отправить", for: .normal)
        button.setTitleColor( UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(shareReview), for: .touchUpInside)
        button.backgroundColor = UIColor.black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var delivery: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.image = UIImage(named: "Important info")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    public func configure() {
        backgroundColor = .white
        print("tommy\(id)")
        addSubview(leaveReview)
        addSubview(yourMark)
        addSubview(cosmosView)
        addSubview(commentTextField)
        addSubview(nameTextField)
        addSubview(share)
        addSubview(delivery)
        
        NSLayoutConstraint.activate([
            leaveReview.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            leaveReview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            yourMark.topAnchor.constraint(equalTo: leaveReview.bottomAnchor, constant: 10),
            yourMark.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            
            cosmosView.topAnchor.constraint(equalTo: leaveReview.bottomAnchor, constant: 10),
            cosmosView.leadingAnchor.constraint(equalTo: yourMark.trailingAnchor, constant: 20),
            
            commentTextField.topAnchor.constraint(equalTo: yourMark.bottomAnchor, constant: 15),
            commentTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            commentTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            commentTextField.heightAnchor.constraint(equalToConstant: 85),
            
            nameTextField.topAnchor.constraint(equalTo: commentTextField.bottomAnchor, constant: 15),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 45),
            
            share.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            share.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            share.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            share.heightAnchor.constraint(equalToConstant: 45),
            
            delivery.topAnchor.constraint(equalTo: share.bottomAnchor, constant: 20),
            delivery.leadingAnchor.constraint(equalTo: leadingAnchor),
            delivery.trailingAnchor.constraint(equalTo: trailingAnchor),
            delivery.heightAnchor.constraint(equalToConstant: 280)
        ])
    }
    
    func showAlert() {
        addSubview(uiView2)
        uiView2.addSubview(sentReview)
        uiView2.layer.cornerRadius = 5
        
        NSLayoutConstraint.activate([
            uiView2.centerYAnchor.constraint(equalTo: centerYAnchor),
            uiView2.centerXAnchor.constraint(equalTo: centerXAnchor),
            uiView2.heightAnchor.constraint(equalToConstant: 30),
            uiView2.widthAnchor.constraint(equalToConstant: 100),
            
            sentReview.centerXAnchor.constraint(equalTo: uiView2.centerXAnchor),
            sentReview.centerYAnchor.constraint(equalTo: uiView2.centerYAnchor)
        
        ])
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
    }

    @objc func dismissAlert(){
        // Dismiss the alert from here
        self.uiView2.removeFromSuperview()
    }
    
    @objc func shareReview() {
        guard let url = URL(string: "http://salomat.tj/products/send_review") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "prod_id": id,
            "review_rating": cosmosView.rating,
            "review_name": nameTextField.text!,
            "review_comment": commentTextField.text!
        ]

        request.httpBody = parameters.percentEncoded()
        print("iiiiiidd \(productShow?.product?.id ?? "")")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
                    
            else {
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    print("Отзыв Добавлен!")
                    self.nameTextField.text = ""
                    self.commentTextField.text = ""
                    self.cosmosView.rating = 0
                    self.showAlert()
                    
                }
            }
            else if response.statusCode == 400 {
                DispatchQueue.main.async {
                    print("FALSE")
                }
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print(json, "first")
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
}
