//
//  Login.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 09/11/22.
//

import Foundation

struct Login: Codable {
    var user_id: String?
    var login: String?
    var password: String?
    var name: String?
    var enabled: String?
    var access: String?
    var birth_date: String?
    var address: String?
    var gender: String?
    var email: String?
    var type: String?
//    var image: String?
//    var onesignal_id: String?
    
    enum CodingKeys: Codable, CodingKey {
        case user_id, login, password, name, enabled
        case access, birth_date, address, gender
        case email, type
    }
}
typealias LoginData = [Login]
