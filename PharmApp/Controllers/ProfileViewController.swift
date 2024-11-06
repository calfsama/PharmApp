//
//  ProfileViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 01/09/22.
//

import UIKit

class ProfileViewController: UIViewController, UITextFieldDelegate {
    var login: LoginData?
    var network = NetworkService()
    var alert: UIAlertController!
    var isLoggedIn: Bool = false
    var isExpand: Bool = false
    var indicator =  UIActivityIndicatorView()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 3200)
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
        label.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Телефон"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "987654321"
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.returnKeyType = .next
        textField.textColor = .black
        textField.backgroundColor = .white
        textField.leftViewMode = .always
        textField.keyboardType = .phonePad
        textField.leftView = prefix
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        textField.addTarget(self, action: #selector(validPhone), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 4
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitle("Войти или зарегистрироваться", for: .normal)
        button.addTarget(self, action: #selector(checkPhone), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var match: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationItem.title = "Вход"
//        configureConstraints()
        textField.delegate = self
        self.hideKeyboard()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardApperence(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
               
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

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureConstraints()
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
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(disKeyboard))
//        tap.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc func disKeyboard() {
        view.endEditing(true)
//        continueButton.removeFromSuperview()
////        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//        scrollView.addSubview(continueButton)
//        NSLayoutConstraint.activate([
//            continueButton.heightAnchor.constraint(equalToConstant: 45),
//            continueButton.widthAnchor.constraint(equalToConstant: view.frame.width - 32),
//            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            continueButton.bottomAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.bottomAnchor, constant: -10),
//
//        ])
    }
        
    @objc func keyboardApperence(notification: NSNotification){
            if !isExpand{
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardHeight = keyboardFrame.cgRectValue.height
                    //self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + keyboardHeight)
                    let height = keyboardHeight
                    self.continueButton.frame.origin.y -= height - 70
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
                    //self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - keyboardHeight)
                    let height = keyboardHeight
                    self.continueButton.frame.origin.y += height - 70
                }
                else{
                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - 250)
                }
                isExpand = false
            }
        }
    
    func configureConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(phone)
        scrollView.addSubview(textField)
        scrollView.addSubview(match)
        scrollView.addSubview(continueButton)
        
        NSLayoutConstraint.activate([
            phone.topAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.topAnchor, constant: 16),
            phone.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            textField.topAnchor.constraint(equalTo: phone.bottomAnchor, constant: 5),
            textField.heightAnchor.constraint(equalToConstant: 45),
            textField.widthAnchor.constraint(equalToConstant: scrollView.frame.width - 32),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            match.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5),
            match.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            continueButton.heightAnchor.constraint(equalToConstant: 45),
            continueButton.widthAnchor.constraint(equalToConstant: view.frame.width - 32),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
        ])
    }
    
    @objc func postRequestButton() {
        let url = URL(string: "http://salomat.tj/users/check_phone")!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "phone": "\(textField)"
        ]
        if textField.text?.count == 9 {
            request.httpBody = parameters.percentEncoded()
        }
        else if (textField.text?.count)! < 9 || (textField.text?.count)! < 9 {
            
        }
       
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
            else { // check for fundamental networking error
                print("error", error ?? URLError(.badServerResponse))
                return
            }
            if response.statusCode >= 200 && response.statusCode <= 299 {
                DispatchQueue.main.async {
                }
            }
            else if response.statusCode == 400 {
                DispatchQueue.main.async {
                    //self.wrongPasswod.text = "Введен неверный пароль"
                }
                
                print("error")
            }
            
            guard (200 ... 299) ~= response.statusCode else { // check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(CheckPhone.self, from: data)
                print(responseObject)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
        }
        task.resume()
    }
    
    func showAlert() {
        self.alert = UIAlertController(title: "", message: "Пароль изменен", preferredStyle: UIAlertController.Style.alert)
        self.present(self.alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
    }

    @objc func dismissAlert(){
        // Dismiss the alert from here
        self.alert.dismiss(animated: true, completion: nil)
    }
    
    @objc func checkPhone() {
        view.endEditing(true)
        guard let url = URL(string: "http://salomat.tj/users/check_phone") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
//        let parameters: [String: Any] = [
//            "phone": textField.text!
//        ]
        
        if (textField.text?.count ?? 0) == 9{
            let parameters: [String: Any] = [
                "phone": textField.text!
            ]
            request.httpBody = parameters.percentEncoded()
            indicator.center = view.center
            continueButton.isEnabled = false
            view.addSubview(indicator)
            indicator.color = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
            indicator.startAnimating()
        }
        else if textField.text == "" {
            self.match.text = "Введите номер телефона"
            self.textField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
        }
        else if textField.text?.count ?? 0 < 9 {
            self.match.text = "Неправильно набран номер"
        }
     
        
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
                    let vc = PasswordViewController()
                    vc.phone = self.textField.text!
                    self.continueButton.isEnabled = true
                    vc.title = "Вход"
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            else if response.statusCode == 400 {
                DispatchQueue.main.async {
                    if (self.textField.text?.count ?? 0) == 9 {
                        self.indicator.stopAnimating()
                        let vc = RegisterViewController()
                        vc.phone = self.textField.text!
                        vc.action = "Registration"
                        self.continueButton.isEnabled = true
                        vc.title = "Регистрация"
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else {
                        self.match.text = "Неправильно набран номер"
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
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
