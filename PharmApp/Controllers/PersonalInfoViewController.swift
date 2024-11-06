//
//  PersonalInfoViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 03/10/22.
//

import UIKit
import KeychainAccess
import ButtonOnKeyboard

class PersonalInfoViewController: UIViewController {
    let dataArray = ["Женский", "Мужской"]
    let picker = UIPickerView()
    var datePicker = UIDatePicker()
    var userID: String = ""
    var network = NetworkService()
    var login: LoginData?
    var token: String = ""
    var profile = ProfileInfoViewController()
    var alert: UIAlertController!
    let keychain = Keychain(service: "tj.info.Salomat")
    var isExpand: Bool = false
    var genderLabel = "Женский"
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: view.frame.size.height)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    lazy var name: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "Имя"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameStar: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "*"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пано Дианова"
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
    
    lazy var gender: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "Пол"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var genderTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Женский"
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
    
    lazy var birthDate: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "Дата рождения"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var birthDateTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "03/11/1999"
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
    
    lazy var email: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "Электронная почта"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "example@gmail.com"
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
    
    lazy var address: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.text = "Адрес"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addressStar: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.text = "*"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "ул. Пушкина"
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
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.setTitle("Сохранить", for: .normal)
        button.setTitleColor( UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(updateUserInfo), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var nameMatch: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var addressMatch: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.937, green: 0.365, blue: 0.439, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
        picker.delegate = self
        picker.dataSource = self
        genderTextField.inputView = picker
//        hideKeyboardWhenTappedAround()
        
        createDatePicker()
        configureConstraints()
        hideKeyboard()
        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(donePressed))
        birthDateTextField.inputAccessoryView = toolBar
//        genderTextField.inputAccessoryView = toolBar
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardApperence(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
               NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappear(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//          NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
          
//          button.bk_defaultButtonHeight = 50  // Stores the default size of the button.
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    func configureConstraints() {
        scrollView.addSubview(name)
        scrollView.addSubview(nameStar)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(email)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(address)
        scrollView.addSubview(addressStar)
        scrollView.addSubview(addressTextField)
        scrollView.addSubview(button)
        scrollView.addSubview(gender)
        scrollView.addSubview(genderTextField)
        scrollView.addSubview(birthDate)
        scrollView.addSubview(birthDateTextField)
        scrollView.addSubview(nameMatch)
        scrollView.addSubview(addressMatch)
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            nameStar.topAnchor.constraint(equalTo: name.topAnchor),
            nameStar.leadingAnchor.constraint(equalTo: name.trailingAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 10),
            nameTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 32),
            nameTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 50),

            nameMatch.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 3),
            nameMatch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            gender.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 15),
            gender.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            genderTextField.topAnchor.constraint(equalTo: gender.bottomAnchor, constant: 10),
            genderTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 32),
            genderTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            genderTextField.heightAnchor.constraint(equalToConstant: 50),

            birthDate.topAnchor.constraint(equalTo: genderTextField.bottomAnchor, constant: 15),
            birthDate.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),

            birthDateTextField.topAnchor.constraint(equalTo: birthDate.bottomAnchor, constant: 10),
            birthDateTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 32),
            birthDateTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            birthDateTextField.heightAnchor.constraint(equalToConstant: 50),

            email.topAnchor.constraint(equalTo: birthDateTextField.bottomAnchor, constant: 15),
            email.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),

            emailTextField.topAnchor.constraint(equalTo: email.bottomAnchor, constant: 10),
            emailTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 32),
            emailTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),

            address.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15),
            address.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),

            addressStar.topAnchor.constraint(equalTo: address.topAnchor),
            addressStar.leadingAnchor.constraint(equalTo: address.trailingAnchor),

            addressTextField.topAnchor.constraint(equalTo: address.bottomAnchor, constant: 10),
            addressTextField.widthAnchor.constraint(equalToConstant: view.frame.width - 32),
            addressTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            addressTextField.heightAnchor.constraint(equalToConstant: 50),

            addressMatch.topAnchor.constraint(equalTo: addressTextField.bottomAnchor, constant: 3),
            addressMatch.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            
            button.widthAnchor.constraint(equalToConstant: view.frame.width - 32),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.bottomAnchor.constraint(equalTo: scrollView.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])
    }
        
    func createDatePicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        //bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        doneButton.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        toolBar.setItems([doneButton], animated: true)
        //assign toolbar
        birthDateTextField.inputAccessoryView = toolBar
        
        // assign date picker to the text field
        birthDateTextField.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
       
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
    }
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(disKeyboard))
//        tap.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tap)
    }
    
    @objc func disKeyboard() {
        view.endEditing(true)
    }
    
    @objc func updateUserInfo() {
        guard let url = URL(string: "http://salomat.tj/users/update_user/\(keychain["UserID"] ?? "")") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "name": nameTextField.text!,
            "email": emailTextField.text!,
            "birth_date": birthDateTextField.text!,
            "address": addressTextField.text!,
            "gender": genderLabel
        ]
        
        if nameTextField.text != "" && addressTextField.text != "" {
            request.httpBody = parameters.percentEncoded()
        }
        else if nameTextField.text == "" && addressTextField.text == ""{
            self.nameMatch.text = "Введите Ваше имя"
            self.addressMatch.text = "Введите Ваш адрес"
            
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
                    self.showAlert(comment: "Изменения сохранены")
                }
            }
            else if response.statusCode == 400 {
                DispatchQueue.main.async {
                    self.showAlert(comment: "Ошибка\n Повторите еще раз")
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
    
    @objc func keyboardApperence(notification: NSNotification){
            if !isExpand{
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardHeight = keyboardFrame.cgRectValue.height
                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + keyboardHeight - 230)
                    let height = keyboardHeight
//                    self.button.frame.origin.y -= height - 80
//                    var bottomConstraint = NSLayoutConstraint(item: self.button, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: height + 80)
//                    self.view.addConstraint(bottomConstraint)
//                    NSLayoutConstraint.activate([bottomConstraint])
                    scrollView.addConstraints([
                        NSLayoutConstraint(
                            item: button,
                            attribute: .bottom,
                            relatedBy: .equal,
                            toItem: scrollView,
                            attribute: .bottom,
                            multiplier: 1,
                            constant: 0),
                    ])
                }
                else{
                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height + 150)
                    
                }
                isExpand = true
            }
        }
        @objc func keyboardDisappear(notification: NSNotification){
            if isExpand{
                if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                    let keyboardHeight = keyboardFrame.cgRectValue.height
                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - keyboardHeight + 230)
                    let height = keyboardHeight
                    self.button.frame.origin.y += height - 80
//                    var bottomConstraint = NSLayoutConstraint(item: self.button, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: scrollView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: height - 80)
//                    self.view.addConstraint(bottomConstraint)
//                    NSLayoutConstraint.activate([bottomConstraint])
                }
                else{
                    self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.scrollView.frame.height - 150)
                }
                isExpand = false
            }
        }
    
    @objc func keyboardWillShow(notification: Notification) {
        self.scrollView.isScrollEnabled = true
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardHeight, right: 0.0)
            self.scrollView.contentInset = contentInsets
            self.scrollView.scrollIndicatorInsets = contentInsets
            var rect = self.view.frame
            rect.size.height -= keyboardHeight
            if !rect.contains(self.button.frame.origin) {
                self.scrollView.scrollRectToVisible(self.button.frame, animated: true)
                
            }
        }
    }
    
//    @objc func keyboardWillShow(_ notification: Notification) {
//        var visibleHeight: CGFloat = 0
//
//        if let userInfo = notification.userInfo {
//            if let windowFrame = UIApplication.shared.keyWindow?.frame,
//                let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//                visibleHeight = windowFrame.intersection(keyboardRect).height
//                self.button.frame.origin.y += visibleHeight - 80
////                updateButtonLayout(height: visibleHeight)
//            }
//        }
//
//            }
//
//    @objc func keyboardWillHide(_ notification: Notification) {
//        updateButtonLayout(height: 0)
//    }
//
//    func updateButtonLayout(height: CGFloat) {
//        button.bk_onKeyboard(scrollView: scrollView, keyboardHeight: height)
//    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        birthDateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
}
extension PersonalInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return dataArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       let row = dataArray[row]
       return row
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextField.text = dataArray[row]
        genderLabel = dataArray[row]
        if dataArray[row] == "Женский" {
            genderLabel = "female"
        }
        else if dataArray[row] == "Мужской" {
            genderLabel = "male"
        }
        print(dataArray[row], "gender")
        genderTextField.resignFirstResponder()
    }
}
//extension UIToolbar {
//
//func ToolbarPiker(mySelect : Selector) -> UIToolbar {
//
//    let toolBar = UIToolbar()
//
//    toolBar.barStyle = UIBarStyle.default
//    toolBar.isTranslucent = true
//    toolBar.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
//    toolBar.sizeToFit()
//
//    let doneButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
//    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//
//    toolBar.setItems([ spaceButton, doneButton], animated: false)
//    toolBar.isUserInteractionEnabled = true
//
//    return toolBar
//}
//
//}

