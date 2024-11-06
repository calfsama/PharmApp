//
//  ElPrescriptionViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 22/08/23.
//

import UIKit

class ElPrescriptionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    lazy var image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        image.layer.masksToBounds = true
        image.image = UIImage(named: "Image-1")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(openCamera), for: .touchUpInside)
        button.setTitle("Camera", for: .normal)
        button.backgroundColor = .blue
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        constrains()
        // Do any additional setup after loading the view.
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
    
    func constrains() {
        view.addSubview(image)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            image.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            image.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            image.heightAnchor.constraint(equalToConstant: 100),
            
            button.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -10),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            button.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            if picker.sourceType == .photoLibrary {
//                if let pickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                    image.image = pickedimage
//                    print("pickedImage", pickedimage.pngData()!)
//                }
//            }
//        else {
            if let pickedimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
                image.image = UIImage(named: "image-2")
                print("pickedImage", pickedimage.pngData()!)
            }
//        }
//            if let pickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
//                imagesArray += [pickedimage]
//                print("pickedImage", pickedimage.pngData()!)
//                receiptCollectionView.reloadData()
//            }
        picker.dismiss(animated: true, completion: nil)
    }
}
