//
//  InfoCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 01/10/22.
//

import UIKit

class InfoCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout {
    var info = [Info]()
    var navigationController: UINavigationController
    
    init(nav: UIViewController) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.navigationController = nav as! UINavigationController
        super.init(frame: .zero, collectionViewLayout: layout)
        register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: InfoCollectionViewCell.identifier)
        delegate = self
        dataSource = self
        showsHorizontalScrollIndicator = false
        translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = 20
        contentInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
        backgroundColor = .white
    }
    func set(cells: [Info]) {
        self.info = cells
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension InfoCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return info.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: InfoCollectionViewCell.identifier, for: indexPath) as! InfoCollectionViewCell
        cell.image.image = info[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.size.width, height: 90)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = WebViewController()
        if indexPath.row == 0 {
            vc.title = "О проекте"
            vc.urlString  = "http://salomat.tj/index.php/main/page/1?is_mobile=true"
        }
        else if indexPath.row == 1 {
            vc.title = "Доставка и оплата"
            vc.urlString = "http://salomat.tj/index.php/main/page/2?is_mobile=true"
        }
        else if indexPath.row == 2 {
            vc.title = "Как сделать заказ"
            vc.urlString = "http://salomat.tj/index.php/main/page/3?is_mobile=true"
        }
        self.navigationController.pushViewController(vc, animated: true)
    }
}
