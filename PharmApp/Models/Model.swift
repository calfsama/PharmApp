//
//  Model.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 01/09/22.
//

import Foundation
import UIKit

struct Categories {
    let image: UIImage
    let title: String
    
    static func items()-> [Categories] {
        let first = Categories(image: UIImage(named: "coronavirus_2877796")!, title: "При аллергии")
        let second = Categories(image: UIImage(named: "vitamin-c_4257322")!, title: "Витамины")
        let third = Categories(image: UIImage(named: "sign_15901208")!, title: "Акции")
        
        return [first, second, third]
    }
}

struct Info {
    let image: UIImage
    
    static func items() -> [Info] {
        let first = Info(image: UIImage(named: "aboutUs 1")!)
        let second = Info(image: UIImage(named: "howToDoOrder")!)
        let third = Info(image: UIImage(named: "delivery&payment")!)
        
        return [first, second, third]
    }
}

struct Settings {
    let image: String
    let title: String
    
    static func items() -> [Settings] {
        let empty = Settings(image: "", title: "")
        let first = Settings(image: "Profile mob", title: "Личная информация")
        let second = Settings(image: "notification", title: "Уведомления и новости")
        let third = Settings(image: "cart", title: "Мои заказы")
        let fourth = Settings(image: "phone", title: "Номер телефона")
        let fifth = Settings(image: "security", title: "Безопасность")
        let sixth = Settings(image: "log out", title: "Выход")
        
        return [empty, first, second, third, fourth, fifth, sixth]
    }
}

struct Messenger {
    let image: UIImage
    
    static func items() -> [Messenger] {
        let first = Messenger(image: UIImage(named: "telegram 1")!)
        let second = Messenger(image: UIImage(named: "whatsapp")!)
        
        return [first, second]
    }
}

