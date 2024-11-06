//
//  SafetyViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 05/10/22.
//

import UIKit

class SafetyViewController: UIViewController {
    var phone: String = ""
    var alert: UIAlertController!
    var condition: Bool = false
    var isExpand: Bool = false
    var indicator =  UIActivityIndicatorView()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height - 150)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.isScrollEnabled = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    lazy var password: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Пароль"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите новый пароль"
        textField.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .asciiCapable
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        textField.addTarget(self, action: #selector(validPassword), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var repeatPassword: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        label.text = "Повторите пароль"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var repeatPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите повторно пароль"
        textField.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .asciiCapable
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        textField.addTarget(self, action: #selector(validRepeatPassword), for: .editingChanged)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(updatePassword), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var match: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var eyeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "eye closed"), for: .normal)
        button.addTarget(self, action: #selector(eyeButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var secondEyeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "eye closed"), for: .normal)
        button.addTarget(self, action: #selector(secondEyeButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureConstraints()
        hideKeyboard()
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureConstraints()
    }
    
    func configureConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(password)
        scrollView.addSubview(passwordTextField)
        scrollView.addSubview(eyeButton)
        scrollView.addSubview(repeatPassword)
        scrollView.addSubview(repeatPasswordTextField)
        scrollView.addSubview(secondEyeButton)
        scrollView.addSubview(button)
        scrollView.addSubview(match)
        
        NSLayoutConstraint.activate([
            password.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            password.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            passwordTextField.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 10),
            passwordTextField.widthAnchor.constraint(equalToConstant: scrollView.frame.size.width - 32),
            passwordTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            eyeButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            eyeButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -20),

            repeatPassword.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            repeatPassword.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            repeatPasswordTextField.topAnchor.constraint(equalTo: repeatPassword.bottomAnchor, constant: 10),
            repeatPasswordTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            repeatPasswordTextField.widthAnchor.constraint(equalToConstant: scrollView.frame.size.width - 32),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: 45),
            
            secondEyeButton.centerYAnchor.constraint(equalTo: repeatPasswordTextField.centerYAnchor),
            secondEyeButton.trailingAnchor.constraint(equalTo: repeatPasswordTextField.trailingAnchor, constant: -20),
            
            match.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 5),
            match.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

           
            button.widthAnchor.constraint(equalToConstant: view.frame.size.width - 32),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 45),
            button.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc func eyeButtonAction() {
        if condition == false {
            condition = true
            eyeButton.setImage(UIImage(named: "Group 1"), for: .normal)
            passwordTextField.isSecureTextEntry = false
        }
        else if condition == true {
            condition = false
            eyeButton.setImage(UIImage(named: "eye closed"), for: .normal)
            passwordTextField.isSecureTextEntry = true
        }
    }
    
    @objc func secondEyeButtonAction() {
        if condition == false {
            condition = true
            secondEyeButton.setImage(UIImage(named: "Group 1"), for: .normal)
            repeatPasswordTextField.isSecureTextEntry = false
        }
        else if condition == true {
            condition = false
            secondEyeButton.setImage(UIImage(named: "eye closed"), for: .normal)
            repeatPasswordTextField.isSecureTextEntry = true
        }
    }
    
    func showAlert(comment: String) {
        self.alert = UIAlertController(title: "", message: comment, preferredStyle: UIAlertController.Style.alert)
        self.present(self.alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
    }

    @objc func dismissAlert(){
        // Dismiss the alert from here
        self.alert.dismiss(animated: true, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func showAlert2(comment: String) {
        self.alert = UIAlertController(title: "", message: comment, preferredStyle: UIAlertController.Style.alert)
        self.present(self.alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(dismissAlert2), userInfo: nil, repeats: false)
    }

    @objc func dismissAlert2(){
        // Dismiss the alert from here
        self.alert.dismiss(animated: true, completion: nil)
    }
    
    @objc func validPassword() {
        if passwordTextField.text?.count ?? 0 <= 7 {
            passwordTextField.layer.borderColor = UIColor.red.cgColor
            passwordTextField.layer.borderWidth = 1
        }
        else {
            passwordTextField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        }
    }
    
    @objc func validRepeatPassword() {
        if passwordTextField.text != repeatPasswordTextField.text {
            repeatPasswordTextField.layer.borderColor = UIColor.red.cgColor
            repeatPasswordTextField.layer.borderWidth = 1
        }
        else {
            repeatPasswordTextField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        }
    }

    @objc func keyboardApperence(notification: NSNotification){
            if !isExpand{
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardHeight = keyboardFrame.cgRectValue.height
                    //self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + keyboardHeight)
                    let height = keyboardHeight
                    self.button.frame.origin.y -= height - 50
                }
                else{
//                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + 250)
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
                    self.button.frame.origin.y += height - 90
                }
                else{
//                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - 250)
                }
                isExpand = false
            }
        }
    
    @objc func updatePassword() {
        view.endEditing(true)
        indicator.center = view.center
        view.addSubview(indicator)
        indicator.color = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        indicator.startAnimating()
        guard let url = URL(string: "http://salomat.tj/users/forgot_password") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "phone": phone,
            "password": passwordTextField.text!
        ]
        if repeatPasswordTextField.text != "" && passwordTextField.text == repeatPasswordTextField.text && passwordTextField.text?.count ?? 0 >= 8{
            request.httpBody = parameters.percentEncoded()
        }
        else if passwordTextField.text?.count ?? 0 <= 7 {
            passwordTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            repeatPasswordTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            match.text = "Пароль должен содержать не менее 8 символов"
        }
        else if repeatPasswordTextField.text == "" || passwordTextField.text == ""{
            passwordTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            repeatPasswordTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            match.text = "Заполните поле"
        }
        else if repeatPasswordTextField.text != passwordTextField.text {
            passwordTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            repeatPasswordTextField.layer.borderColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1).cgColor
            match.text = "Пароли не совпадают"
        }
        
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
                    self.indicator.stopAnimating()
                    self.showAlert(comment: "Пароль изменен")
                    print("update")
                }
            }
            else if response.statusCode == 400 {
                DispatchQueue.main.async {
                  print("error")
                    self.indicator.stopAnimating()
                    self.showAlert2(comment: "Ошибка")
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
}

