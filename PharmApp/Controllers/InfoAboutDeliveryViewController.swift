//
//  InfoAboutDeliveryViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 13/10/22.
//

import UIKit
import KeychainAccess

class InfoAboutDeliveryViewController: UIViewController, UITextFieldDelegate {
    var isExpand: Bool = false
    var keychain = Keychain(service: "tj.info.Salomat")
    var discount: String = ""
    var network = NetworkService()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height + 150)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    lazy var uiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        uiView.layer.cornerRadius = 4
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var uiView2: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        uiView.layer.cornerRadius = 4
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var uiView3: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 1)
        uiView.layer.cornerRadius = 4
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var star: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.textColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var star2: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.textColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var star3: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.textColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var star4: UILabel = {
        let label = UILabel()
        label.text = "*"
        label.textColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.text = "Имя Фамилия"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var reqiered: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var reqiered2: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
    
    lazy var phone: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "Номер телефона"
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.keyboardType = .phonePad
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
    
    lazy var additionalPhone: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "Телефон, если мы не дозвонимся"
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var additionalPTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .phonePad
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var street: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "Улица"
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var streetTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
    
    lazy var house: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "Дом"
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var houseTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
    
    lazy var referencePoint: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "Ориентир"
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var referencePointTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
    
    lazy var comments: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.text = "Комментарии"
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var commentsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
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
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Продолжить", for: .normal)
        button.layer.cornerRadius = 4
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.backgroundColor = UIColor.black
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        keychain["order"] = ""
        userShow()
        print(discount, "discount")
        hideKeyboardWhenTappedAround()
        configureConstraints()
        phoneTextField.delegate = self
        additionalPTextField.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardApperence), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
        
    func userShow() {
        guard let url = URL(string: "http://salomat.tj/users/show/\(keychain["UserID"] ?? "")") else { return }
        var request = URLRequest(url: url)
        request.setValue(keychain["Token"] ?? "", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(self.keychain["Token"] ?? "")
                print(response)
            }
            guard
                let data = data,
                let _ = response as? HTTPURLResponse,
                error == nil
                    
            else { //check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            
            do {
                let responseObject = try JSONDecoder().decode(LoginData.self, from: data)
                DispatchQueue.main.async {
                    let userData = responseObject
                    self.nameTextField.text = userData[0].name ?? ""
                    self.phoneTextField.text = userData[0].login ?? ""
                    self.streetTextField.text = userData[0].address ?? ""
                }
                print(responseObject)
            } catch {
                print(error)
        
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
        }.resume()
    }
    
    func updateUserInfo() {
        guard let url = URL(string: "http://salomat.tj/users/update_user/\(keychain["UserID"] ?? "")") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "name": nameTextField.text!,
            "address": (streetTextField.text! + houseTextField.text!),
            "phone": phoneTextField.text!
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
                    
            else { //check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    print("success")
                }
            }
            else if response.statusCode == 400 {
                DispatchQueue.main.async {
                  print("errrooor")
                }

                print("user doesn't exist")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print(json, "first")
            }
            catch {
                print(error, "second")
            }
        }
        task.resume()
    }

    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 9
    }

    
    @objc func keyboardApperence(notification: NSNotification){
            if !isExpand{
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardHeight = keyboardFrame.cgRectValue.height
                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + keyboardHeight - 250)
//                    self.button.frame.origin.y -= keyboardHeight - 80
                   
                }
                else{
                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + 250)
                }
                isExpand = true
            }
        }
        @objc func keyboardDisappear(notification: NSNotification){
            if isExpand{
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardHeight = keyboardFrame.cgRectValue.height
                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - keyboardHeight + 250)
//                    self.button.frame.origin.y += keyboardHeight - 80
                }
                else{
                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - 250)
                }
                isExpand = false
            }
            
        }
    
    func validate() {
        if streetTextField.text == "" && nameTextField.text == "" && houseTextField.text == "" && phoneTextField.text == ""{
            streetTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            nameTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            houseTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            phoneTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
        }
        else if nameTextField.text == "" && phoneTextField.text == "" && houseTextField.text == ""{
            nameTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            phoneTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            houseTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
        }
        else if streetTextField.text == "" && phoneTextField.text == "" && houseTextField.text == ""{
            streetTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            phoneTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            houseTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
        }
        else if streetTextField.text == "" && nameTextField.text == "" && houseTextField.text == ""{
            streetTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            nameTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            houseTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
        }
        else if phoneTextField.text == "" && nameTextField.text == "" {
            nameTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            phoneTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
        }
        else if phoneTextField.text == "" && houseTextField.text == "" {
            nameTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            houseTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
        }
        else if houseTextField.text == "" && streetTextField.text == "" {
            houseTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            streetTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
        }
        else if nameTextField.text == "" && streetTextField.text == "" {
            nameTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            streetTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
        }
        else if nameTextField.text == "" {
            nameTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
        }
        else if phoneTextField.text == "" {
            phoneTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
        }
        else if houseTextField.text == "" {
            houseTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
        }
        else if streetTextField.text == "" {
            streetTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
        }
    }
    
    func configureConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(uiView)
        scrollView.addSubview(uiView2)
        scrollView.addSubview(uiView3)
        scrollView.addSubview(name)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(phone)
        scrollView.addSubview(phoneTextField)
        scrollView.addSubview(additionalPhone)
        scrollView.addSubview(additionalPTextField)
        scrollView.addSubview(street)
        scrollView.addSubview(streetTextField)
        scrollView.addSubview(house)
        scrollView.addSubview(houseTextField)
        scrollView.addSubview(referencePoint)
        scrollView.addSubview(referencePointTextField)
        scrollView.addSubview(comments)
        scrollView.addSubview(commentsTextField)
        scrollView.addSubview(button)
        scrollView.addSubview(star)
        scrollView.addSubview(star2)
        scrollView.addSubview(star3)
        scrollView.addSubview(star4)
        scrollView.addSubview(reqiered)
        scrollView.addSubview(reqiered2)
        
        NSLayoutConstraint.activate([
            
            uiView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            uiView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            uiView.heightAnchor.constraint(equalToConstant: 3),
            uiView.widthAnchor.constraint(equalToConstant: view.frame.size.width / 3.5),
            
            uiView2.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            uiView2.leadingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: 11),
            uiView2.heightAnchor.constraint(equalToConstant: 3),
            uiView2.widthAnchor.constraint(equalToConstant: view.frame.size.width / 3.5),
            
            uiView3.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            uiView3.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            uiView3.heightAnchor.constraint(equalToConstant: 3),
            uiView3.widthAnchor.constraint(equalToConstant: view.frame.size.width / 3.5),
            
            name.topAnchor.constraint(equalTo: uiView.bottomAnchor, constant: 20),
            name.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
            star.topAnchor.constraint(equalTo: name.topAnchor, constant: -3),
            star.leadingAnchor.constraint(equalTo: name.trailingAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameTextField.heightAnchor.constraint(equalToConstant: 45),
            
            phone.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            phone.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
            star2.topAnchor.constraint(equalTo: phone.topAnchor, constant: -3),
            star2.leadingAnchor.constraint(equalTo: phone.trailingAnchor),
            
            phoneTextField.topAnchor.constraint(equalTo: phone.bottomAnchor, constant: 10),
            phoneTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            phoneTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            phoneTextField.heightAnchor.constraint(equalToConstant: 45),
            
            reqiered2.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            reqiered2.leadingAnchor.constraint(equalTo: star2.trailingAnchor, constant: 5),
            
            additionalPhone.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 15),
            additionalPhone.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
            additionalPTextField.topAnchor.constraint(equalTo: additionalPhone.bottomAnchor, constant: 10),
            additionalPTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            additionalPTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            additionalPTextField.heightAnchor.constraint(equalToConstant: 45),
            
            street.topAnchor.constraint(equalTo: additionalPTextField.bottomAnchor, constant: 15),
            street.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
            star3.topAnchor.constraint(equalTo: street.topAnchor, constant: -3),
            star3.leadingAnchor.constraint(equalTo: street.trailingAnchor),
            
            streetTextField.topAnchor.constraint(equalTo: street.bottomAnchor, constant: 10),
            streetTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            streetTextField.trailingAnchor.constraint(equalTo: houseTextField.leadingAnchor, constant: -10),
            streetTextField.heightAnchor.constraint(equalToConstant: 45),
            
            house.topAnchor.constraint(equalTo: additionalPTextField.bottomAnchor, constant: 15),
            house.leadingAnchor.constraint(equalTo: streetTextField.trailingAnchor, constant: 10),
            
            star4.topAnchor.constraint(equalTo: house.topAnchor, constant: -3),
            star4.leadingAnchor.constraint(equalTo: house.trailingAnchor),
            
            houseTextField.topAnchor.constraint(equalTo: house.bottomAnchor, constant: 10),
            houseTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            houseTextField.widthAnchor.constraint(equalToConstant: 55),
            houseTextField.heightAnchor.constraint(equalToConstant: 45),
            
            referencePoint.topAnchor.constraint(equalTo: streetTextField.bottomAnchor, constant: 15),
            referencePoint.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
            referencePointTextField.topAnchor.constraint(equalTo: referencePoint.bottomAnchor, constant: 10),
            referencePointTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            referencePointTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            referencePointTextField.heightAnchor.constraint(equalToConstant: 45),
            
            comments.topAnchor.constraint(equalTo: referencePointTextField.bottomAnchor, constant: 15),
            comments.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
            commentsTextField.topAnchor.constraint(equalTo: comments.bottomAnchor, constant: 10),
            commentsTextField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            commentsTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            commentsTextField.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -60),
            commentsTextField.heightAnchor.constraint(equalToConstant: 65),
            
            reqiered.topAnchor.constraint(equalTo: commentsTextField.bottomAnchor, constant: 5),
            reqiered.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
//            button.topAnchor.constraint(equalTo: commentsTextField.bottomAnchor, constant: 45),
            button.topAnchor.constraint(equalTo: commentsTextField.bottomAnchor, constant: 30),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            button.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    @objc func buttonAction() {
        if phoneTextField.text == "" || nameTextField.text == "" || streetTextField.text == "" || houseTextField.text == "" {
            reqiered.text = "Заполните обязательные поля"
            validate()
        }
        
        else if nameTextField.text != "" && phoneTextField.text != "" && streetTextField.text != "" && houseTextField.text != "" {
            if phoneTextField.text?.count ?? 0 < 9 {
                reqiered2.text = "Телефон должен состоять из 9 чисел"
            }
            else if phoneTextField.text?.count == 9 {
                let vc = InfoAboutDeliveryTwoViewController()
                vc.title = "Информация о доставке"
                updateUserInfo()
                vc.discount = discount
                vc.name = nameTextField.text!
                vc.phone_number = phoneTextField.text!
                vc.phone_number2 = additionalPTextField.text!
                vc.address = streetTextField.text! + " " + houseTextField.text! + " " + referencePointTextField.text!
                vc.comment = commentsTextField.text!
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
