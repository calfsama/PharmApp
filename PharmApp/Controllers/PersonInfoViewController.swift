//
//  PersonInfoViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 12/07/23.
//

import UIKit
import KeychainAccess
import ButtonOnKeyboard

class PersonInfoViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
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
    var nameText: String = ""
    var genderText: String = ""
    var dateText: String = ""
    var mailText: String = ""
    var addressText: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        details()
        createDatePicker()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        scrollView.addGestureRecognizer(tapGesture)
    }
    
    func details() {
        nameTextField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        genderTextField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        dateTextField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        mailTextField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        addressTextField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor
        
        nameTextField.layer.borderWidth = 1.0
        genderTextField.layer.borderWidth = 1.0
        dateTextField.layer.borderWidth = 1.0
        mailTextField.layer.borderWidth = 1.0
        addressTextField.layer.borderWidth = 1.0
        
        nameTextField.layer.cornerRadius = 4
        genderTextField.layer.cornerRadius = 4
        dateTextField.layer.cornerRadius = 4
        mailTextField.layer.cornerRadius = 4
        addressTextField.layer.cornerRadius = 4
        
        nameTextField.delegate = self
        mailTextField.delegate = self
        
        nameTextField.text = nameText
        genderTextField.text = genderText
        dateTextField.text = dateText
        mailTextField.text = mailText
        addressTextField.text = addressText
        
        mailTextField.addTarget(self, action: #selector(validEmail), for: .editingChanged)
        
        picker.delegate = self
        picker.dataSource = self
        
        genderTextField.inputView = picker
        
        saveButton.backgroundColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1)
        saveButton.setTitle("Сохранить", for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        saveButton.setTitleColor( UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        saveButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        saveButton.layer.cornerRadius = 4
        saveButton.addTarget(self, action: #selector(updateUserInfo), for: .touchUpInside)
//
//        let toolBar = UIToolbar().ToolbarPiker(mySelect: #selector(donePressed))
//        dateTextField.inputAccessoryView = toolBar

    }
    
    @objc func validEmail() {
        if let email = mailTextField.text {
            if let errorMessage = isValidEmail(email) {
                mailTextField.layer.borderColor = UIColor.red.cgColor
                mailTextField.layer.borderWidth = 1
            }
            else {
                mailTextField.layer.borderColor = UIColor(red: 0.929, green: 0.93, blue: 1, alpha: 1).cgColor

            }
        }
    }
    
    func isValidEmail(_ email: String) -> String? {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if !emailPred.evaluate(with: email) {
            return "Invalide email address"
        }
        return nil
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        var visibleHeight: CGFloat = 0
         
        if let userInfo = notification.userInfo {
            if let windowFrame = UIApplication.shared.keyWindow?.frame,
                let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                visibleHeight = windowFrame.intersection(keyboardRect).height - 20
            }
        }
        
        updateButtonLayout(height: visibleHeight)
    }
     
    @objc func keyboardWillHide(_ notification: Notification) {
        updateButtonLayout(height: 50)
    }
    
    func updateButtonLayout(height: CGFloat) {
        saveButton.bk_onKeyboard(scrollView: scrollView, keyboardHeight: height)
    }
    
    @objc func dismissPicker() {
        view.endEditing(true)
    }
    
    @objc func updateUserInfo() {
        self.view.endEditing(true)
        guard let url = URL(string: "http://salomat.tj/users/update_user/\(keychain["UserID"] ?? "")") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "name": nameTextField.text!,
            "email": mailTextField.text!,
            "birth_date": dateTextField.text!,
            "address": addressTextField.text!,
            "gender": genderLabel
        ]
        
        if nameTextField.text != "" && addressTextField.text != "" {
            request.httpBody = parameters.percentEncoded()
        }
        else if nameTextField.text == "" && addressTextField.text == ""{
//            self.nameMatch.text = "Введите Ваше имя"
//            self.addressMatch.text = "Введите Ваш адрес"
            
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
    
    func createDatePicker() {
//        let toolBar = UIToolbar()
//        toolBar.sizeToFit()
//        //bar button
//        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
//        doneButton.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
//        toolBar.setItems([doneButton], animated: true)
//        //assign toolbar
//        dateTextField.inputAccessoryView = toolBar

        // assign date picker to the text field
        dateTextField.inputView = datePicker

        //date picker mode
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChange), for: .valueChanged)

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
//        dateTextField.text = formatDate(date: datePicker.date)
    }
    
    @objc func dateChange() {
        dateTextField.text = formatDate(date: datePicker.date)
    }
    

    func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .none
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter.string(from: date)
    }
}
extension PersonInfoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
extension UIToolbar {

func ToolbarPiker(mySelect : Selector) -> UIToolbar {

    let toolBar = UIToolbar()

    toolBar.barStyle = UIBarStyle.default
    toolBar.isTranslucent = true
    toolBar.tintColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
    toolBar.sizeToFit()

    let doneButton = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.plain, target: self, action: mySelect)
    let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)

    toolBar.setItems([ spaceButton, doneButton], animated: false)
    toolBar.isUserInteractionEnabled = true

    return toolBar
}

}
extension PersonInfoViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == nameTextField {
            let allowedCharacter = CharacterSet.letters
            let allowedCharacter1 = CharacterSet.whitespaces
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacter.isSuperset(of: characterSet) || allowedCharacter1.isSuperset(of: characterSet)
        }
        else if textField == mailTextField {
            let allowedCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz@."
            let allowedCharacterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            let alphabet = allowedCharacterSet.isSuperset(of: typedCharacterSet)
            return alphabet
        }
        else {
            return false
        }
    }
}


