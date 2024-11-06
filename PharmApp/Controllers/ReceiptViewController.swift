//
//  ReceiptViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 01/09/22.
//

import UIKit
import Photos

@objc protocol SendImages: class {
    @objc func update(phone: String, name: String, comment: String)
}

class ReceiptViewController: UIViewController, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var receiptCollectionView = ReceiptCollectionView()
    var imagePickerController = UIImagePickerController()
    var alert: UIAlertController!
    var pending = UIAlertController()
    var indicator =  UIActivityIndicatorView()
    var workoutState = false
    var text: String = ""
    var startDate = Date()
    var timer = Timer()
    var seconds = 60
    var phoneNumber = ""
    var name_recipe = ""
    var comment_recipe = ""
    
    var imagesArray: [UIImage] = [
    UIImage(named: "photo")!]

    struct Constants {
        static let backgroundAlphaTo:  CGFloat = 0.6
    }
    
    let time: UILabel = {
        let time = UILabel()
        time.text = "01:00"
        time.textAlignment = .center
        time.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        time.translatesAutoresizingMaskIntoConstraints = false
        return time
    }()

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
    
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "image 6")
        return image
    }()
    
    lazy var resendSMSButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.backgroundColor = .white
        button.setTitle("Отправить еще раз", for: .normal)
        button.setTitleColor(UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1), for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1).cgColor
        button.layer.borderWidth = 1
        //cancelButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var titleAlert: UILabel = {
        let label = UILabel()
        label.text = "Введите код, который был Вам отправлен"
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var writeCode: UILabel = {
        let label = UILabel()
        label.text = "Введите код из смс"
        label.numberOfLines = 0
        label.textColor =  UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var codeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "_ _ _ _"
        textField.font = UIFont.systemFont(ofSize: 24, weight: .regular)
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
    
    lazy var resending: UILabel = {
        let label = UILabel()
        label.text = "Повторная отправка сообщения будет доступна через:"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor =  UIColor(red: 0.478, green: 0.463, blue: 0.617, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.backgroundColor = .white
        button.setTitle("Отменить", for: .normal)
        button.setTitleColor(UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1), for: .normal)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.layer.borderColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1).cgColor
        button.layer.borderWidth = 1
        //cancelButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    lazy var continueButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Продолжить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        // continueButton.addTarget(self, action: #selector(checkCode), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //checkPermissions()
        for var i in 0...imagesArray.count - 1 {
            print("qwerty", imagesArray[i])
            i += 1
        }
        
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
        receiptCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.identifier)
        receiptCollectionView.register(ReceiptCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ReceiptCollectionReusableView.identifier)
        receiptCollectionView.register(ReceiptHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReceiptHeaderCollectionReusableView.identifier)
        receiptCollectionView.delegate = self
        receiptCollectionView.dataSource = self
        navigationItem.title = "Электронный рецепт"
        configureConstraints()
    }
    
    @objc func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            present(picker, animated: true)
        }
        
    }
    

    @objc func actionSheet() {
        let alert = UIAlertController(title: "Выберите фото рецепта", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Камера", style: .default, handler: { (handler) in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Галерея", style: .default, handler: { (handler) in
            self.gallery()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .default, handler: { (handler) in
            print("cancel")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // -MARK: CREATE ALERT WITH ACTIVITY INDICATOR
    func showSpinner() {
        pending = UIAlertController(title: "", message: nil, preferredStyle: .alert)
        //create an activity indicator
        indicator = UIActivityIndicatorView(frame: pending.view.bounds)
        indicator.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        //add the activity indicator as a subview of the alert controller's view
        pending.view.addSubview(indicator)
        indicator.isUserInteractionEnabled = false // required otherwise if there buttons in the UIAlertController you will not be able to press them
        indicator.startAnimating()
        
        self.present(pending, animated: true, completion: nil)
    }

    func configureConstraints() {
        view.addSubview(receiptCollectionView)

        NSLayoutConstraint.activate([
            receiptCollectionView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            receiptCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            receiptCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            receiptCollectionView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0)
        ])
    }
    
    
    // Open gallery
     @objc func gallery() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            self.imagePickerController.sourceType = .photoLibrary
            self.imagePickerController.allowsEditing = true
            self.imagePickerController.delegate = self
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
    }
    private var myTargetView: UIView?
    
    // Create custom alert
    func showAlert(with title: String, message: String, on viewController: UIViewController) {
        guard let targetView = viewController.view else { return }
        myTargetView = targetView
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        
        alertView.frame = CGRect(x: 40, y: -300, width: targetView.frame.size.width - 120, height: 300)
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(titleLabel)
        
        let image = UIImageView()
        image.image = UIImage(named: "done")
        image.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(image)
        
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 4
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor(red: 0.118, green: 0.745, blue: 0.745, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        alertView.addSubview(button)
        self.backgroundView.alpha = Constants.backgroundAlphaTo
        self.alertView.center = targetView.center
        
        // Constraints
        image.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 30).isActive = true
        image.centerXAnchor.constraint(equalTo: alertView.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16).isActive = true
        button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        button.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 60).isActive = true
        button.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -60).isActive = true
        button.heightAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    @objc func dismissAlert() {
        guard let targetView = myTargetView else { return }
        self.alertView.frame = CGRect(x: 40, y: targetView.frame.size.height, width: targetView.frame.size.width - 80, height: 300)
        self.backgroundView.alpha = 0
        self.alertView.removeFromSuperview()
        self.backgroundView.removeFromSuperview()
    }
    
    func showAlert(message: String) {
        self.alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        self.present(self.alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(dismissAlertController), userInfo: nil, repeats: false)
    }
    
    func showAlertController() {
        self.alert = UIAlertController(title: "", message: "Рецепт отправлен", preferredStyle: UIAlertController.Style.alert)
        self.present(self.alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(dismissAlertController), userInfo: nil, repeats: false)
    }

    @objc func dismissAlertController(){
        // Dismiss the alert from here
        self.alert.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissSpinner(){
        // Dismiss the alert from here
        self.pending.dismiss(animated: true, completion: nil)
    }
}
extension ReceiptViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.identifier, for: indexPath) as! PhotoCollectionViewCell
        if indexPath.row >= 1 {
            cell.photo.layer.borderColor = UIColor(red: 0.738, green: 0.741, blue: 1, alpha: 1).cgColor
            cell.photo.layer.borderWidth = 1
            cell.cancelButton.layer.setValue(indexPath.row, forKey: "index")
            cell.cancelButton.addTarget(self, action: #selector(deleteUser), for: .touchUpInside)
            cell.cancelButton.setImage(UIImage(named: "cancel"), for: .normal)
        }
        else if indexPath.row == 0 {
            cell.cancelButton.layer.setValue(indexPath.row, forKey: "index")
            cell.cancelButton.addTarget(self, action: #selector(empty), for: .touchUpInside)
            cell.cancelButton.setImage(UIImage(named: ""), for: .normal)
            cell.photo.layer.borderWidth = 0
        }
        cell.photo.layer.cornerRadius = 4
        cell.photo.layer.masksToBounds = true
        cell.photo.image = imagesArray[indexPath.row]
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ReceiptHeaderCollectionReusableView.identifier, for: indexPath) as! ReceiptHeaderCollectionReusableView
            header.configure()
            return header
            
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ReceiptCollectionReusableView.identifier, for: indexPath) as! ReceiptCollectionReusableView
            footer.nameTextField.text = text
            footer.phoneTextField.text = text
            footer.commentTextField.text = text
            footer.send = self
            footer.configureConstraints()
            footer.userShow()
            footer.images = imagesArray
            return footer
            
            
        default:
            fatalError("Unexpected element kind")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 55)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height - 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 * 0.75  , height: collectionView.frame.size.width / 3 * 0.73)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            gallery()
        }
    }
    
    @objc func deleteUser(sender:UIButton) {
        let i : Int = (sender.layer.value(forKey: "index")) as! Int
        let objectToDelete = imagesArray.remove(at: i)
        receiptCollectionView.reloadData()
    }
    
    @objc func empty() {
        
    }

    // extension for impage uploading
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if picker.sourceType == .photoLibrary {
//                if let pickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                    imagesArray += [pickedimage]
//                    print("pickedImage", pickedimage.pngData()!)
//                    receiptCollectionView.reloadData()
//                }
//            }
//        else {
            if let pickedimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                imagesArray += [pickedimage]
                print("pickedImage", pickedimage.pngData()!)
                print("count", imagesArray.count)
                receiptCollectionView.reloadData()
            }
//        }
//            if let pickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                imagesArray += [pickedimage]
//                print("pickedImage", pickedimage.pngData()!)
//                receiptCollectionView.reloadData()
//            }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
        
    }

    func createRequest1(param : [String: Any] , strURL : String) -> NSURLRequest {
        
        let boundary = generateBoundaryString()
        
        let url = NSURL(string: strURL)
        let request = NSMutableURLRequest(url: url! as URL)
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = createBodyWithParameters(parameters: param, boundary: boundary)
        NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: .main, completionHandler: {(request, data, error) in
            guard let data = data else { return }
            let responseString: String = String(data: data, encoding: .utf8)!
            print("my_log" + responseString)
            DispatchQueue.main.async {
                self.dismissSpinner()
                self.imagesArray = [
                UIImage(named: "image 6")!]
                self.text = ""
                self.showAlertController()
                self.receiptCollectionView.reloadData()
            }
        })
        return request
    }

    func createBodyWithParameters(parameters: [String: Any],boundary: String) -> Data {
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters {
                
                if(value is String || value is NSString){
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString(string: "\(value)\r\n")
                }
                else if(value is [UIImage]){
                    var i = 0;
                    for image in value as! [UIImage]{
                        let filename = "image\(i).jpg"
                        let data = image.jpegData(compressionQuality: 1);
                        let mimetype = "image/jpeg"
                        
                        body.appendString(string: "--\(boundary)\r\n")
                        body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(filename)\"\r\n")
                        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
                        body.append(data!)
                        body.appendString(string: "\r\n")
                        i += 1
                    }
                }
            }
        }
        body.appendString(string: "--\(boundary)--\r\n")
        return body as Data
    }
    
    // Create custom alert for SMS
    func showAlertForSMS(on viewController: UIViewController) {
        guard let targetView = viewController.view else { return }
        myTargetView = targetView
        backgroundView.frame = targetView.bounds
        targetView.addSubview(backgroundView)
        targetView.addSubview(alertView)
        alertView.frame = CGRect(x: 40, y: -300, width: targetView.frame.size.width - 120, height: 350)
        alertView.addSubview(time)
        alertView.addSubview(titleAlert)
        alertView.addSubview(writeCode)
        alertView.addSubview(codeTextField)
        alertView.addSubview(resending)
        alertView.addSubview(cancelButton)
        alertView.addSubview(continueButton)
        self.backgroundView.alpha = Constants.backgroundAlphaTo
        self.alertView.center = targetView.center
        
        // Constraints
        titleAlert.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 16).isActive = true
        titleAlert.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16).isActive = true
        titleAlert.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16).isActive = true
        
        writeCode.topAnchor.constraint(equalTo: titleAlert.bottomAnchor, constant: 10).isActive = true
        writeCode.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16).isActive = true
        writeCode.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16).isActive = true
        
        codeTextField.topAnchor.constraint(equalTo: writeCode.bottomAnchor, constant: 8).isActive = true
        codeTextField.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16).isActive = true
        codeTextField.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16).isActive = true
        codeTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        resending.topAnchor.constraint(equalTo: codeTextField.bottomAnchor, constant: 10).isActive = true
        resending.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16).isActive = true
        resending.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16).isActive = true
        
        time.topAnchor.constraint(equalTo: resending.bottomAnchor, constant: 20).isActive = true
        time.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16).isActive = true
        time.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16).isActive = true
        
        cancelButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20).isActive = true
        cancelButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: continueButton.leadingAnchor, constant: -8).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        cancelButton.addTarget(self, action: #selector(dismissAlert), for: .touchUpInside)
        
        continueButton.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -20).isActive = true
        continueButton.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16).isActive = true
        continueButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor, constant: 8).isActive = true
        continueButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        continueButton.addTarget(self, action: #selector(checkCode), for: .touchUpInside)
        startTimer()
       
    }
    
    func updateTimerLabel() {
        let interval = -Int(startDate.timeIntervalSinceNow)
        let hours = interval / 3600
        let minutes = interval / 60 % 60
        let seconds = interval % 60
        time.text = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func startTimer() {
        workoutState = true
        _foregroundTimer(repeated: true)
    }
    
    func _foregroundTimer(repeated: Bool) -> Void {
         NSLog("_foregroundTimer invoked.");
         //Define a Timer
         self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
         print("Starting timer")

     }

    @objc func updateTime() {
        if seconds > 0 {
            seconds -= 1
            var minutes = 0
            // timer.text = "00:\(seconds)"
            time.text = String(format:"%02i:%02i", minutes, seconds)
        }
        else {
            timer.invalidate()
            time.text = "00:00"
            time.removeFromSuperview()
            alertView.addSubview(resendSMSButton)
            resendSMSButton.topAnchor.constraint(equalTo: resending.bottomAnchor,constant: 16).isActive = true
            resendSMSButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            resendSMSButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
            resendSMSButton.widthAnchor.constraint(equalToConstant: alertView.frame.size.width - 100).isActive = true
            resendSMSButton.addTarget(self, action: #selector(resendSMS), for: .touchUpInside)
        }
    }
    
    @objc func resendSMS() {
        time.text = "01:00"
        seconds = 60
        resendSMSButton.removeFromSuperview()
        alertView.addSubview(time)
        time.topAnchor.constraint(equalTo: resending.bottomAnchor, constant: 20).isActive = true
        time.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 16).isActive = true
        time.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -16).isActive = true
        startTimer()
        sendSMS(phone: self.phoneNumber)
    }
}

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding(rawValue: NSUTF8StringEncoding), allowLossyConversion: true)
        append(data!)
    }
}

extension ReceiptViewController: SendImages {
    @objc func update(phone: String, name: String, comment: String) {
        
        if phone == "" || name == "" {
            showAlert(message: "Заполните поля")
        }
        else if imagesArray.count == 1 {
            showAlert(message: "Загрузите рецепт")
        }
        else {
            showAlertForSMS(on: self)
            phoneNumber = phone
            name_recipe = name
            comment_recipe = comment
            
            //self.showSpinner()
            // MARK: - SEND SMS
            sendSMS(phone: phone)
        }
    }
    
    // MARK: - Request for send SMS
    func sendSMS(phone: String) {
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
    
    //
    @objc func checkCode() {
        guard let url = URL(string: "http://salomat.tj/users/check_register_code") else { return }
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "phone": phoneNumber,
            "confirm_code": codeTextField.text!
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
                    self.dismissAlert()
                    self.showSpinner()
                    let parameters: [String: Any] = [
                        "recipe_phone": self.phoneNumber,
                        "recipe_name": self.name_recipe,
                        "recipe_comment": self.comment_recipe,
                        "recipe_pics": self.imagesArray
                    ]
                    let urlStr = "http://salomat.tj/recipes/store"
                    self.createRequest1(param: parameters, strURL: urlStr)
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
}


