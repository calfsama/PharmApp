//
//  MessangerCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 27/10/22.
//

import UIKit

class MessangerCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    var data = [Messenger]()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        register(MessangerCollectionViewCell.self, forCellWithReuseIdentifier: MessangerCollectionViewCell.identifier)
        delegate = self
        dataSource = self
        contentInset = UIEdgeInsets(top: 0, left: 23, bottom: 0, right: 23)
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = true
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(cell: [Messenger]) {
        self.data = cell
    }
    
    @objc func openWhatsApp() {
        let whatsApp = "https://wa.me/992903909990"
        let whatsAppUrl = URL(string: whatsApp)!
        if UIApplication.shared.canOpenURL(whatsAppUrl)
        {
            UIApplication.shared.open(whatsAppUrl)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.open(URL(string: "https://apps.apple.com/ru/app/whatsapp-messenger/id310633997")!)
        }
    }
    
    @objc func openViber() {
        let viber = "viber://chat?number=992903909990"
        let viberURL = URL(string: viber)!
        if UIApplication.shared.canOpenURL(viberURL) {
            UIApplication.shared.open(viberURL)
        }
        else {
            UIApplication.shared.open(URL(string: "https://apps.apple.com/ru/app/viber-messenger-chats-calls/id382617920")!)
        }
    }
    
    @objc func openTelegram() {
        let telegram = "https://t.me/Salomat9990"
        let telegramURL = URL(string: telegram)!
        if UIApplication.shared.canOpenURL(telegramURL) {
            UIApplication.shared.open(telegramURL)
        }
        else {
            UIApplication.shared.open(URL(string: "https://apps.apple.com/us/app/telegram-messenger/id686449807")!)
        }
    }
    
}
extension MessangerCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessangerCollectionViewCell.identifier, for: indexPath) as! MessangerCollectionViewCell
        cell.button.setImage(data[indexPath.row].image, for: .normal)
        if indexPath.row == 0 {
            cell.button.addTarget(self, action: #selector(openTelegram), for: .touchUpInside)
        }
        else if indexPath.row == 1 {
            cell.button.addTarget(self, action: #selector(openWhatsApp), for: .touchUpInside)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2 * 0.7, height: 75)
    }
}
