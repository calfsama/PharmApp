//
//  RecoveryPasswordStepThreeViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 01/10/22.
//

import UIKit

class RecoveryPasswordStepThreeViewController: UIViewController {
    var condition: Bool = false
    var phone: String = ""
    var alert: UIAlertController!

    lazy var password: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "Новый пароль"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
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
    
    lazy var repeatPassword: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.text = "Повторить новый пароль"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var repeatPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.isSecureTextEntry = true
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
    
    lazy var cancel: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.backgroundColor = .white
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1), for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var register: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Продолжить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(changePassword), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        configureConstraints()
        self.hideKeyboardWhenTappedAround()
    }
    
    func showAlert() {
        self.alert = UIAlertController(title: "", message: "Пароль изменен", preferredStyle: UIAlertController.Style.alert)
        self.present(self.alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
    }

    @objc func dismissAlert(){
        // Dismiss the alert from here
        self.alert.dismiss(animated: true, completion: nil)
        let v = ProfileViewController()
        v.title = "Вход"
        self.navigationController?.pushViewController(v, animated: true)
    }
    
    func configureConstraints() {
        view.addSubview(password)
        view.addSubview(passwordTextField)
        view.addSubview(eyeButton)
        view.addSubview(repeatPassword)
        view.addSubview(repeatPasswordTextField)
        view.addSubview(secondEyeButton)
        view.addSubview(cancel)
        view.addSubview(register)
        view.addSubview(match)
        
        NSLayoutConstraint.activate([
            password.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 16),
            password.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            passwordTextField.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 45),
            passwordTextField.widthAnchor.constraint(equalToConstant: 330),
            
            eyeButton.centerYAnchor.constraint(equalTo: passwordTextField.centerYAnchor),
            eyeButton.trailingAnchor.constraint(equalTo: passwordTextField.trailingAnchor, constant: -20),
            
            repeatPassword.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            repeatPassword.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            repeatPasswordTextField.topAnchor.constraint(equalTo: repeatPassword.bottomAnchor,constant: 5),
            repeatPasswordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            repeatPasswordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            repeatPasswordTextField.heightAnchor.constraint(equalToConstant: 45),
            repeatPasswordTextField.widthAnchor.constraint(equalToConstant: 330),
            
            secondEyeButton.centerYAnchor.constraint(equalTo: repeatPasswordTextField.centerYAnchor),
            secondEyeButton.trailingAnchor.constraint(equalTo: repeatPasswordTextField.trailingAnchor, constant: -20),
            
            match.topAnchor.constraint(equalTo: repeatPasswordTextField.bottomAnchor, constant: 5),
            match.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            cancel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            cancel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancel.heightAnchor.constraint(equalToConstant: 45),
            cancel.widthAnchor.constraint(equalToConstant: 160),
            
            register.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            register.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            register.leadingAnchor.constraint(equalTo: cancel.trailingAnchor, constant: 16),
            register.heightAnchor.constraint(equalToConstant: 45),
            register.widthAnchor.constraint(equalToConstant: 160)
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
    
    @objc func changePassword() {
        guard let url = URL(string: "http://salomat.tj/users/forgot_password") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "phone": phone,
            "password": passwordTextField.text!
        ]
        if passwordTextField.text == repeatPasswordTextField.text {
            request.httpBody = parameters.percentEncoded()
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
            }
            guard
                let data = data,
                let response = response as? HTTPURLResponse,
                error == nil
                    
            else {
                print("errorrr", error ?? URLError(.badServerResponse))
                return
            }
            if response.statusCode == 200 {
                DispatchQueue.main.async {
                    if self.passwordTextField.text == self.repeatPasswordTextField.text {
                            self.showAlert()
                    }
                }
                print("Пароль изменён")
            }
            else if response.statusCode == 400 {
                if self.passwordTextField.text != self.repeatPasswordTextField.text {
                    DispatchQueue.main.async {
                        self.match.text = "Пароли не совпадают"
                    }
                }
                print("error")
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print(json)
            }
            catch {
                print(error)
            }
            guard (200 ... 299) ~= response.statusCode else {                     //check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
        }
        task.resume()
    }
}
