//
//  PhoneNumberViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 13/10/22.
//

import UIKit
import KeychainAccess

class PhoneNumberViewController: UIViewController {
    var phoneNumber: String = ""
    var userID: String = ""
    var personalInfo = PersonalInfoViewController()
    var login: LoginData?
    var token: String = ""
    var alert: UIAlertController!
    var indicator =  UIActivityIndicatorView()
    var keychain = Keychain(service: "tj.info.Salomat")
    var isExpand: Bool = false
    private var myTargetView: UIView?
    
    struct Constants {
        static let backgroundAlphaTo:  CGFloat = 0.6
    }
    
    lazy var backgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .black
        backgroundView.alpha = 0
        return backgroundView
    }()
    
    lazy var alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.layer.cornerRadius = 12
        alert.layer.masksToBounds = true
        return alert
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height - 150)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    lazy var  prefix: UILabel = {
        let label = UILabel()
        label.text = "  +992 "
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        label.sizeToFit()
        return label
    }()
    
    lazy var phone: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "Номер телефона"
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "932 55 44 55"
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.returnKeyType = .next
        textField.keyboardType = .phonePad
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.leftView = prefix
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        textField.addTarget(self, action: #selector(validPhone), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor( UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(checkPhone), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        textField.delegate = self
        title = "Номер телефона"
        hideKeyboard()
        configureConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardApperence(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyb))
//        tap.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyb() {
        view.endEditing(true)
    }
    
    func configureConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(phone)
        scrollView.addSubview(textField)
        scrollView.addSubview(button)
        
        NSLayoutConstraint.activate([
            phone.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 30),
            phone.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            textField.topAnchor.constraint(equalTo: phone.bottomAnchor, constant: 10),
            textField.widthAnchor.constraint(equalToConstant: view.frame.size.width - 32),
            textField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: 45),
            
            button.bottomAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.bottomAnchor, constant: -20),
            button.widthAnchor.constraint(equalToConstant: scrollView.frame.size.width - 32),
            button.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    func showAlert(comment: String) {
        self.alert = UIAlertController(title: "", message: comment, preferredStyle: UIAlertController.Style.alert)
        self.present(self.alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
    }
    
    @objc func keyboardApperence(notification: NSNotification){
            if !isExpand{
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardHeight = keyboardFrame.cgRectValue.height
                    let height = keyboardHeight
                    self.button.frame.origin.y -= height - 80
                   
                }
                else{
                }
                isExpand = true
            }
        }
        @objc func keyboardDisappear(notification: NSNotification){
            if isExpand{
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardHeight = keyboardFrame.cgRectValue.height
                    let height = keyboardHeight
                    self.button.frame.origin.y += height - 80
                }
                else{
                }
                isExpand = false
            }
            
        }
    
    func showAlert() {
        self.alert = UIAlertController(title: "", message: "Номер изменен", preferredStyle: UIAlertController.Style.alert)
        self.present(self.alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
    }

    @objc func dismissAlert(){
        // Dismiss the alert from here
        self.alert.dismiss(animated: true, completion: nil)
    }
    
    @objc func updatePhone() {
        guard let url = URL(string: "http://salomat.tj/users/update_user/\(keychain["UserID"] ?? "")") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "login": textField.text!,
            "comfirm": 0 ,
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
                    self.showAlert()
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
    
    @objc func validPhone() {
        if textField.text?.count != 9 {
            textField.layer.borderColor = UIColor.red.cgColor
            textField.layer.borderWidth = 1
        }
        else {
            textField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        }
    }
    
    @objc func checkPhone() {
        view.endEditing(true)
        guard let url = URL(string: "http://salomat.tj/users/check_phone") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "phone": textField.text!
        ]
        
        if (textField.text?.count ?? 0) == 9{
            let parameters: [String: Any] = [
                "phone": textField.text!
            ]
            request.httpBody = parameters.percentEncoded()
            indicator.center = view.center
            view.addSubview(indicator)
            indicator.color = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
            indicator.startAnimating()
        }
//        else if textField.text == "" {
//            self.match.text = "Введите номер телефона"
//            self.textField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
//        }
//        else if textField.text?.count ?? 0 < 9 {
//            self.match.text = "Неправильно набран номер"
//        }
             
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
                    
            else {  //check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.showAlert(comment: "Есть пользователь с таким номером")
                    
                }
            }
            else if response.statusCode == 400 {
                DispatchQueue.main.async {
                    if (self.textField.text?.count ?? 0) == 9 {
                        self.indicator.stopAnimating()
                        let vc = RegisterViewController()
                        vc.title = "Смена номера"
                        vc.phone = self.textField.text!
                        vc.action = "Change number"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                    }

                }
                print("user doesn't exist")
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
extension PhoneNumberViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 9
    }
}
