//
//  PasswordViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 26/09/22.
//

import UIKit
import SwiftKeychainWrapper
import KeychainAccess

class PasswordViewController: UIViewController {
    var phone: String = ""
    var network = NetworkService()
    var userData: Token?
    var token: String = ""
    var userID: String = ""
    var fcmToken: String = ""
    var appDelegate = AppDelegate()
    var condition: Bool = false
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
    
    lazy var password: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.text = "Пароль"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.returnKeyType = .next
        textField.isSecureTextEntry = true
        textField.leftViewMode = .always
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.keyboardType = .asciiCapable
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.layer.cornerRadius = 4
        textField.layer.borderWidth = 1
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var signUp: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitle("Забыли пароль?", for: .normal)
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(recoveryButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.backgroundColor = UIColor.black
        button.layer.cornerRadius = 4
        button.titleLabel?.font =  UIFont.systemFont(ofSize: 12, weight: .regular)
        button.setTitle("Войти", for: .normal)
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
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
    
    lazy var wrongPasswod: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureConstraints()
        //        hideKeyboardWhenTappedAround()
        hideKeyboard()
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardApperence(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureConstraints()
    }
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(disKeyboard))
//        tap.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc func disKeyboard() {
        view.endEditing(true)
//        continueButton.removeFromSuperview()
////        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)//
        scrollView.addSubview(signUp)
        scrollView.addSubview(continueButton)
        NSLayoutConstraint.activate([
            signUp.bottomAnchor.constraint(equalTo: continueButton.layoutMarginsGuide.topAnchor, constant: -16),
            signUp.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            signUp.heightAnchor.constraint(equalToConstant: 45),
            signUp.widthAnchor.constraint(equalToConstant: 330),
            signUp.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            continueButton.bottomAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.bottomAnchor, constant: -20),
            continueButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            continueButton.heightAnchor.constraint(equalToConstant: 45),
            continueButton.widthAnchor.constraint(equalToConstant: 330),
            continueButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)

        ])
    }

    
    func configureConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(password)
        scrollView.addSubview(textField)
        scrollView.addSubview(eyeButton)
        scrollView.addSubview(signUp)
        scrollView.addSubview(continueButton)
        scrollView.addSubview(wrongPasswod)
        
        NSLayoutConstraint.activate([
            password.topAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.topAnchor, constant: 16),
            password.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
            textField.topAnchor.constraint(equalTo: password.bottomAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            textField.heightAnchor.constraint(equalToConstant: 45),
            textField.widthAnchor.constraint(equalToConstant: 330),
            textField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            eyeButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            eyeButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -20),
            
            wrongPasswod.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 5),
            wrongPasswod.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),

            signUp.bottomAnchor.constraint(equalTo: continueButton.layoutMarginsGuide.topAnchor, constant: -16),
            signUp.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            signUp.heightAnchor.constraint(equalToConstant: 45),
            signUp.widthAnchor.constraint(equalToConstant: 330),
            signUp.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),

            continueButton.bottomAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.bottomAnchor, constant: -20),
            continueButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            continueButton.heightAnchor.constraint(equalToConstant: 45),
            continueButton.widthAnchor.constraint(equalToConstant: 330),
            continueButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ])
    }
    
    @objc func eyeButtonAction() {
        if condition == false {
            condition = true
            eyeButton.setImage(UIImage(named: "Group 1"), for: .normal)
            textField.isSecureTextEntry = false
        }
        else if condition == true {
            condition = false
            eyeButton.setImage(UIImage(named: "eye closed"), for: .normal)
            textField.isSecureTextEntry = true
        }
    }
    
    @objc func recoveryButton() {
        view.endEditing(true)
        let vc = RecoveryViewController()
        vc.title = "Восстановление пароля"
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        vc.phoneNumber = phone
        vc.navigationItem.backBarButtonItem = backBarButton
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func login() {
        view.endEditing(true)
        indicator.center = view.center
        indicator.color = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        view.addSubview(indicator)
        indicator.startAnimating()
        guard let url = URL(string: "http://salomat.tj/users/login") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let keychain = Keychain(service: "tj.info.Salomat")
        let parameters: [String: Any] = [
            "phone": "\(phone)",
            "password": textField.text!,
            "oneSignalId": keychain["fcmToken"] ?? ""
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
                print(error ?? URLError(.badServerResponse))
                return
            }
            
            do {
                let urlData = try JSONDecoder().decode(Token.self, from: data)
                self.userData = urlData
                let user_id = self.userData?.data?[0].user_id ?? ""
                let token = self.userData?.data?[0].token ?? ""
                let keychain = Keychain(service: "tj.info.Salomat")
                keychain["UserID"] = user_id
                print(keychain["fcmToken"] ?? "", "fcmToken")
                keychain["Token"] = token
            }catch let jsonError {
                print("Failed to decode JSON", jsonError)
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                }
            }
            
            if response.statusCode >= 200 && response.statusCode <= 299 {
                DispatchQueue.main.async {
                   // save data in Keychain
                    self.indicator.stopAnimating()
                    let keychain = Keychain(service: "tj.info.Salomat")
                    keychain["UserID"] = self.userData?.data?[0].user_id ?? ""
                    keychain["Token"] = self.userData?.data?[0].token ?? ""
                    let vc = ProfileInfoViewController()
                    vc.title = "Профиль"
                    vc.userID = self.userData?.data?[0].user_id ?? ""
                    vc.token = self.userData?.data?[0].token ?? ""
                    vc.phone = self.phone
                    if let tabBarController = self.tabBarController {
//                        let reg = MainTabBarViewController()
//                        let appDelegate = UIApplication.shared.delegate
//                        appDelegate?.window??.rootViewController = reg
                       // tabBarController.selectedIndex = 4
                        let profilePage = ProfileInfoViewController()
                        let profilePageNavigation = UINavigationController(rootViewController: profilePage)
                        let profilePageItem = TabBarItem(title: "Профиль", image: UIImage(named: "profile.icon"), selectedImage: UIImage(named: "profile.selected.icon")?.withRenderingMode(.alwaysOriginal))
                        profilePageNavigation.tabBarItem = profilePageItem
                        var newViewController = ProfileInfoViewController()
                        var navigationController = UINavigationController(rootViewController: newViewController)
                        var viewControllers = tabBarController.viewControllers
                        viewControllers?[4] = profilePageNavigation
                        if keychain["id"] == "Корзина" {
                            if let tabBarController = self.tabBarController {
                                tabBarController.viewControllers = viewControllers
                                tabBarController.selectedIndex = 3
                                print("Корзина")
                                keychain["order"] = "order"
                            }
                        }
                        else {
                            tabBarController.viewControllers = viewControllers
                            print("Профиль")
                        }
                    }
                }
            }
            else if response.statusCode == 400 {
                DispatchQueue.main.async {
                    self.wrongPasswod.text = "Введен неверный пароль"
                    self.indicator.stopAnimating()
                }
                
                print("user doesn't exist")
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data)
                print(json)
            }
            catch {
                print(error)
            }
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
        }
        task.resume()
    }
    
    @objc func keyboardApperence(notification: NSNotification){
        if !isExpand{
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardHeight = keyboardFrame.cgRectValue.height
                let height = keyboardHeight
                self.signUp.frame.origin.y -= height - 60
                self.continueButton.frame.origin.y -= height - 60
                
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
                self.signUp.frame.origin.y += height - 80
                self.continueButton.frame.origin.y += height - 80
            }
            else{
            }
            isExpand = false
        }
    }
}
        

