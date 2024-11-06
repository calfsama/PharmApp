//
//  MainTabBarViewController.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 28/11/22.
//

import UIKit
import SwiftKeychainWrapper
import KeychainAccess

class MainTabBarViewController: UITabBarController, UITabBarControllerDelegate {
    let keychain = Keychain(service: "tj.info.Salomat")
   
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor =  .black
        self.delegate = self
    }

   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let home = MainViewController()
        let homeNavigation = UINavigationController(rootViewController: home)
        let homeItem = TabBarItem(title: "Главная", image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        homeNavigation.tabBarItem = homeItem
        
        let favorite = FavoritesViewController()
        let favoriteNavigation = UINavigationController(rootViewController: favorite)
        let favoriteItem = TabBarItem(title: "Избранное", image: UIImage(systemName: "suit.heart"), selectedImage: UIImage(systemName: "suit.heart.fill"))
       
        favoriteNavigation.tabBarItem = favoriteItem
        
        let receipt = ReceiptViewController()
        let receiptNavigation = UINavigationController(rootViewController: receipt)
        let receiptItem = TabBarItem(title: "е-рецепт", image: UIImage(systemName: "receipt.icon"), selectedImage: UIImage(systemName: "camera.selected.icon"))
        receiptNavigation.tabBarItem = receiptItem
        
        let cart = CartViewController()
        let cartNavigation = UINavigationController(rootViewController: cart)
        let cartItem = TabBarItem(title: "Корзина", image: UIImage(systemName: "basket"), selectedImage: UIImage(systemName: "basket.fill"))
//        cartItem.badgeValue = String(basket.count)
//        cartItem.badgeColor = UIColor(red: 0.282, green: 0.224, blue: 0.765, alpha: 1)
        cartNavigation.tabBarItem = cartItem
        
        let profile = ProfileViewController()
        let profileNavigation = UINavigationController(rootViewController: profile)
        let profileItem = TabBarItem(title: "Профиль", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal))
        profileNavigation.tabBarItem = profileItem
        
        let profilePage = ProfileInfoViewController()
        let profilePageNavigation = UINavigationController(rootViewController: profilePage)
        let profilePageItem = TabBarItem(title: "Профиль", image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill")?.withRenderingMode(.alwaysOriginal))
        profilePageNavigation.tabBarItem = profilePageItem
        
        if keychain["Token"] == "" || keychain["Token"] == nil {
            viewControllers = [homeNavigation, favoriteNavigation, cartNavigation,  profileNavigation]
            //selectedIndex = 4
        }
        else  {
            viewControllers = [homeNavigation, favoriteNavigation, cartNavigation, profilePageNavigation]
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print("Selected \(viewController.title!)")
    }
}
