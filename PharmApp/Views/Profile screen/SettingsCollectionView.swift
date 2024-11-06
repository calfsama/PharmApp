//
//  SettingsCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 01/10/22.
//

extension String {
    var html2Attributed: NSAttributedString? {
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                NSAttributedString.DocumentType.html]
        
        do {
            guard let data = data(using: String.Encoding.unicode) else {
                return nil
            }
            return try NSMutableAttributedString(data: data ?? Data(),
                                          options: options,
                                          documentAttributes: nil)
        } catch {
            print("error: ", error)
            return nil
        }
    }
}

import UIKit
import SwiftKeychainWrapper
import KeychainAccess

class SettingsCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    var navigationController: UINavigationController
    var settings = [Settings]()
    var userID: String = ""
    var token: String = ""
    var phone: String = ""
    let keychain = Keychain(service: "tj.info.Salomat")

    init(nav: UIViewController) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.navigationController = nav as! UINavigationController
        super.init(frame: .zero, collectionViewLayout: layout)
        register(SettingsCollectionViewCell.self, forCellWithReuseIdentifier: SettingsCollectionViewCell.identifier)
//        delegate = self
//        dataSource = self
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = 0
        showsHorizontalScrollIndicator = false
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
