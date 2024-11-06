//
//  RegisterViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 01/10/22.
//

import UIKit
import KeychainAccess

class RegisterViewController: UIViewController {
    var phone: String = ""
    var smsCode: String = ""
    var startDate = Date()
    var workoutState = false
    var timer2 = Timer()
    var minutes = 1
    var seconds = 60
    var action = ""
    var alert: UIAlertController!
    var keychain = Keychain(service: "tj.info.Salomat")
    
    lazy var icon: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Information two")
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var buttonForSendSMS: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.backgroundColor = .white
        button.setTitle("Отправить еще раз", for: .normal)
        button.setTitleColor(UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1), for: .normal)
        button.layer.cornerRadius = 4
        button.isHidden = true
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var code: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.text = "Введите код из смс"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "_ _ _ _"
        textField.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        textField.returnKeyType = .next
        textField.leftViewMode = .always
        textField.keyboardType = .phonePad
        textField.textAlignment = .center
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
    
    lazy var repeatMessage: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.text = "Повторная отправка сообщения будет доступна через:"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timer: UILabel = {
        let label = UILabel()
        label.text = "01:00"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        button.addTarget(self, action: #selector(goback), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Продолжить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(checkCode), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var agree: UILabel = {
        let label = UILabel()
        label.text = "Нажав на кнопку “Продолжить”, я принимаю"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor =  UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var usl: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitleColor(UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1), for: .normal)
        button.setTitle("условия пользования", for: .normal)
        button.addTarget(self, action: #selector(termsOfUse), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func updateTime() {
        if seconds > 0 {
            seconds -= 1
            let minutes = 0
           // timer.text = "00:\(seconds)"
            timer.text = String(format:"%02i:%02i", minutes, seconds)
        }
        else {
            timer2.invalidate()
            timer.text = "00:00"
            timer.isHidden = true
            buttonForSendSMS.isHidden = false
            buttonForSendSMS.addTarget(self, action: #selector(updateTimer), for: .touchUpInside)
        }
    }
    
    @objc func updateTimer() {
        timer.text = "01:00"
        seconds = 60
        buttonForSendSMS.isHidden = true
        timer.isHidden = false
        startTimer()
        sendSMS()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        sendSMS()
        startTimer()
        configureConstraints()
        if action == "Change password" || action == "Change number"{
            agree.isHidden = true
            usl.isHidden = true
            icon.isHidden = true
        }
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        self.hideKeyboardWhenTappedAround()
    }
    
    @objc func termsOfUse() {
        let vc = WebViewController()
        vc.urlString = "http://salomat.tj/index.php/main/page/5"
        self.present(vc, animated: true)
        
    }
    
    func updateTimerLabel() {
        let interval = -Int(startDate.timeIntervalSinceNow)
        let hours = interval / 3600
        let minutes = interval / 60 % 60
        let seconds = interval % 60
        timer.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)

    }

    
    func startTimer() {
        workoutState = true
        _foregroundTimer(repeated: true)
    }
    
    func _foregroundTimer(repeated: Bool) -> Void {
         NSLog("_foregroundTimer invoked.");
         //Define a Timer
         self.timer2 = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true);
         print("Starting timer")

     }
    
    @objc func timerAction(_ timer: Timer) {
        updateTimerLabel()
    }
    
    func configureConstraints() {
        view.addSubview(code)
        view.addSubview(textField)
        view.addSubview(repeatMessage)
        view.addSubview(timer)
        view.addSubview(cancel)
        view.addSubview(continueButton)
        view.addSubview(agree)
        view.addSubview(usl)
        view.addSubview(buttonForSendSMS)
        view.addSubview(icon)
        
        NSLayoutConstraint.activate([
            code.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            code.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            textField.topAnchor.constraint(equalTo: code.bottomAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.heightAnchor.constraint(equalToConstant: 45),
            textField.widthAnchor.constraint(equalToConstant: 330),
            
            repeatMessage.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 40),
            repeatMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            repeatMessage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 26),
            
            timer.topAnchor.constraint(equalTo: repeatMessage.bottomAnchor,constant: 16),
            timer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonForSendSMS.topAnchor.constraint(equalTo: repeatMessage.bottomAnchor,constant: 16),
            buttonForSendSMS.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonForSendSMS.heightAnchor.constraint(equalToConstant: 45),
            buttonForSendSMS.widthAnchor.constraint(equalToConstant: 150),
            
            icon.bottomAnchor.constraint(equalTo: agree.topAnchor, constant: -10),
            icon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            agree.bottomAnchor.constraint(equalTo: usl.topAnchor),
            agree.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            agree.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            usl.bottomAnchor.constraint(equalTo: cancel.topAnchor, constant: -20),
            usl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            cancel.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            cancel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cancel.heightAnchor.constraint(equalToConstant: 45),
            cancel.widthAnchor.constraint(equalToConstant: 160),
            
            continueButton.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            continueButton.leadingAnchor.constraint(equalTo: cancel.trailingAnchor, constant: 20),
            continueButton.heightAnchor.constraint(equalToConstant: 45),
            continueButton.widthAnchor.constraint(equalToConstant: 160)
        ])
    }
    
    @objc func goback() {
        navigationController?.popToRootViewController(animated: true)
    }
    func showAlert(comment: String) {
        self.alert = UIAlertController(title: "", message: comment, preferredStyle: UIAlertController.Style.alert)
        self.present(self.alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
    }

    @objc func dismissAlert(){
        // Dismiss the alert from here
        self.alert.dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func checkCode() {
        guard let url = URL(string: "http://salomat.tj/users/check_register_code") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "phone": phone,
            "confirm_code": textField.text!
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
                    let vc = RegisterStepTwoViewController()
                    if self.action == "Change password" {
                        vc.title = "Восстановление пароля"
                        vc.action = self.action
                        vc.phone = self.phone
                        self.navigationController?.pushViewController(vc, animated: true)
                       
                    }
                    else if self.action == "Registration"{
                        vc.title = "Регистрация"
                        vc.action = self.action
                        vc.phone = self.phone
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    else if self.action == "Change number" {
                        self.updatePhone()
                    }
                }
            }
            else if response.statusCode == 400 {
                DispatchQueue.main.async {
                   
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
            guard (200 ... 299) ~= response.statusCode else { //check for http errors
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                return
            }
        }
        task.resume()
    }
    func sendSMS() {
        guard let url = URL(string: "http://salomat.tj/users/resend_sms") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "phone": phone
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
                print("errorrr", error ?? URLError(.badServerResponse))
                return
            }
            if response.statusCode >= 200 && response.statusCode <= 299 {
                DispatchQueue.main.async {
                    //codeTextField.text =
                }
            }
            else if response.statusCode == 400 {
                DispatchQueue.main.async {
                    //self.wrongPasswod.text = "Введен неверный пароль"
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
    
     func updatePhone() {
        guard let url = URL(string: "http://salomat.tj/users/update_user/\(keychain["UserID"] ?? "")") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "login": phone,
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
                    self.showAlert(comment: "Номер изменен")
                }
            }
            else if response.statusCode == 400 {
                DispatchQueue.main.async {
                  print("errrooor")
                    self.showAlert(comment: "Ошибка")
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
