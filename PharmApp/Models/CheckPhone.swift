//
//  CheckPhone.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 03/11/22.
//

import Foundation

struct CheckPhone: Codable {
    var user_id: String?
    var login: String?
    var password: String?
//    var name: String?
//    var enabled: String?
//    var access: String?
//    var birth_date: String?
//    var address: String?
//    var gender: String?
//    var email: String?
//    var type: String?
//    var image: String?
    
    enum CodingKeys: String, CodingKey {
        case user_id, login, password
    }
}
