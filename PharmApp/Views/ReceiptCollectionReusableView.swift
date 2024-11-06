//
//  ReceiptCollectionReusableView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 29/11/22.
//

import UIKit
import MobileCoreServices
import UniformTypeIdentifiers
import KeychainAccess

class ReceiptCollectionReusableView: UICollectionReusableView, UITextFieldDelegate {
    static let identifier = "ReceiptCollectionReusableView"
    var messangerButton = MessangerCollectionView()
    var imagesArray = [String]()
    var images = [UIImage]()
    var login: LoginData?
    let keychain = Keychain(service: "tj.info.Salomat")
    
    var send: SendImages?
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1)
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.setTitle("Отправить рецепт", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.layer.cornerRadius = 4
        button.addTarget(self, action: #selector(show), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var or: UILabel = {
        let label = UILabel()
        label.text = "или"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.22, green: 0.208, blue: 0.325, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sendPhoto: UILabel = {
        let label = UILabel()
        label.text = "отправить фото рецепта по мессенджеру"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var uiView: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 1)
        uiView.layer.cornerRadius = 4
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var uiView2: UIView = {
        let uiView = UIView()
        uiView.backgroundColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 1)
        uiView.layer.cornerRadius = 4
        uiView.translatesAutoresizingMaskIntoConstraints = false
        return uiView
    }()
    
    lazy var phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Телефон"
        textField.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        textField.returnKeyType = .next
        textField.keyboardType = .phonePad
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
        textField.placeholder = "Имя и фамилия"
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
    
    lazy var commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Комментарий"
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
    
    lazy var alertView: UIView = {
        let alert = UIView()
        alert.backgroundColor = .white
        alert.translatesAutoresizingMaskIntoConstraints = false
        return alert
    }()
    
    lazy var titleLabel: UILabel = {
        var titleLabel = UILabel()
        titleLabel.text = "Рецепт отправлен"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "done")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var alertButton: UIButton = {
        let button = UIButton()
        button.setTitle("На главную", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(show), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        messangerButton.set(cell: Messenger.items())
        phoneTextField.delegate = self
    }
    
    @objc func show() {
        send?.update(phone: phoneTextField.text!, name: nameTextField.text!, comment: commentTextField.text!)
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
    
    func showAlert() {
        addSubview(alertView)
        alertView.layer.cornerRadius = 12
        alertView.layer.borderColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1).cgColor
        alertView.layer.borderWidth = 0.5
        alertView.addSubview(titleLabel)
        alertView.addSubview(image)
        alertView.addSubview(alertButton)
        
        // Constraints
        
        NSLayoutConstraint.activate([
            alertView.bottomAnchor.constraint(equalTo: button.topAnchor, constant: -10),
            alertView.centerXAnchor.constraint(equalTo: centerXAnchor),
            alertView.heightAnchor.constraint(equalToConstant: 200),
            alertView.widthAnchor.constraint(equalToConstant: 170),
            image.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 30),
            image.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 70),
            image.widthAnchor.constraint(equalToConstant: 70),
            titleLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16),
            alertButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            alertButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16),
            alertButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16),
            alertButton.heightAnchor.constraint(equalToConstant: 35),
        ])
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
                    self.login = responseObject
                    self.nameTextField.text = self.login?[0].name ?? "Имя не указано"
                    self.phoneTextField.text = self.login?[0].login ?? "Почта не указана"
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
    
    func configureConstraints() {
       // addSubview(alertView)
        addSubview(phoneTextField)
        addSubview(nameTextField)
        addSubview(commentTextField)
        addSubview(button)
        addSubview(or)
        addSubview(uiView)
        addSubview(uiView2)
        addSubview(messangerButton)
        addSubview(sendPhoto)
        
        
        NSLayoutConstraint.activate([
            
            phoneTextField.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            phoneTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            phoneTextField.heightAnchor.constraint(equalToConstant: 45),
            
            nameTextField.topAnchor.constraint(equalTo: phoneTextField.bottomAnchor, constant: 10),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameTextField.heightAnchor.constraint(equalToConstant: 45),
            
            commentTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10),
            commentTextField.leadingAnchor.constraint(equalTo: leadingAnchor),
            commentTextField.trailingAnchor.constraint(equalTo: trailingAnchor),
            commentTextField.heightAnchor.constraint(equalToConstant: 80),
            
            button.topAnchor.constraint(equalTo: commentTextField.bottomAnchor, constant: 10),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.heightAnchor.constraint(equalToConstant: 45),
            
            or.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 25),
            or.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            or.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            uiView.centerYAnchor.constraint(equalTo: or.centerYAnchor),
            uiView.leadingAnchor.constraint(equalTo: leadingAnchor),
            uiView.widthAnchor.constraint(equalToConstant: frame.size.width / 2 * 0.84),
            uiView.heightAnchor.constraint(equalToConstant: 0.7),
            
            uiView2.centerYAnchor.constraint(equalTo: or.centerYAnchor),
            uiView2.trailingAnchor.constraint(equalTo: trailingAnchor),
            uiView2.widthAnchor.constraint(equalToConstant: frame.size.width / 2 * 0.84),
            uiView2.heightAnchor.constraint(equalToConstant: 0.7),
            
            messangerButton.topAnchor.constraint(equalTo: or.bottomAnchor, constant: 25),
            messangerButton.widthAnchor.constraint(equalToConstant: frame.width  * 0.95),
            messangerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            messangerButton.heightAnchor.constraint(equalToConstant: 100),
            
            sendPhoto.topAnchor.constraint(equalTo: messangerButton.bottomAnchor, constant: 20),
            sendPhoto.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            sendPhoto.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension URL {
    /// Mime type for the URL
    ///
    /// Requires `import UniformTypeIdentifiers` for iOS 14 solution.
    /// Requires `import MobileCoreServices` for pre-iOS 14 solution

    var mimeType: String {
        if #available(iOS 14.0, *) {
            return UTType(filenameExtension: pathExtension)?.preferredMIMEType ?? "application/octet-stream"
        } else {
            guard
                let identifier = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(),
                let mimeType = UTTypeCopyPreferredTagWithClass(identifier, kUTTagClassMIMEType)?.takeRetainedValue() as String?
            else {
                return "application/octet-stream"
            }
            return mimeType
        }
    }
}

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}




