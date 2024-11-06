//
//  BannerCollectionView.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 02/09/22.
//

import UIKit
import Kingfisher
import SkeletonView

class BannerCollectionView: UICollectionView {
    var banners: MainSliders?
    var navigationController: UINavigationController
    
    init(nav: UIViewController) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.navigationController = nav as! UINavigationController
        super.init(frame: .zero, collectionViewLayout: layout)
        register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: BannerCollectionViewCell.identifier)
        delegate = self
        dataSource = self
        showsHorizontalScrollIndicator = false
        layout.minimumLineSpacing = 16
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .white
        isPagingEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension BannerCollectionView: UICollectionViewDelegate, SkeletonCollectionViewDataSource {
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return BannerCollectionViewCell.identifier
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners?.main_slider?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: BannerCollectionViewCell.identifier, for: indexPath) as! BannerCollectionViewCell
        let url = "http://salomat.tj/upload_banner/"
        let completeURL = url + (banners?.main_slider?[indexPath.row].slider_pic ?? "")
//        cell.image.downloaded(from: completeURL)
        cell.image.kf.indicatorType = .activity
        print("image url = \(completeURL)")
        let imagel = "http://salomat.tj/upload_banner/sales.jpg"
        let imagelink = URL(string: "https://www.marketscreener.com/images/twitter_ZB_fdnoir.png")
        let image = URL(string: "https://salomat.tj/upload_banner/сайт_(06_2023).png")
//        cell.image.downloaded(from: imagel)
//        ImageDownloader.downloadImage(imagel) {
//           image, urlString in
//              if let imageObject = image {
//                 // performing UI operation on main thread
//                 DispatchQueue.main.async {
//                     cell.image.image = imageObject
//                 }
//              }
//           }
        
        cell.image.kf.setImage(with: URL(string: completeURL))
//        cell.image.image = UIImage(named: "сайт_(06_2023)")
        cell.image.hideSkeleton()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let string = banners?.main_slider?[indexPath.row].slider_link ?? ""
        let components = NSURL(fileURLWithPath: string).pathComponents!.dropFirst()
       // print(components, "components")
        
        if components[5] == "product" {
            let vc = AboutProductViewController()
            vc.id = components[6]
            vc.title = banners?.main_slider?[indexPath.row].slider_name ?? ""
            navigationController.pushViewController(vc, animated: true)
        }
        else if components[5] == "sales" {
            let vc = MedicinesViewController()
            vc.id = components[6]
            vc.title = banners?.main_slider?[indexPath.row].slider_name ?? ""
            navigationController.pushViewController(vc, animated: true)
        }
        else {
            print("not found", components[5])
            let str = components[5]
            let splitStringArray = str.split(separator: "?", maxSplits: 1).map(String.init)
            print(splitStringArray[0])
            if splitStringArray[0] == "searchProductResult" {
                let vc = SearchViewController()
                vc.title = banners?.main_slider?[indexPath.row].slider_name ?? ""
                vc.searchProduct = banners?.main_slider?[indexPath.row].slider_name ?? ""
                navigationController.pushViewController(vc, animated: true)
            }
        }
    }
}
extension BannerCollectionView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: 170)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
