//
//  token.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 13/11/22.
//

import Foundation

struct Token: Codable {
    var data: [TokenData]?
    var message: String?
    var status: Bool?
    
    enum CodingKeys: Codable, CodingKey {
        case status, data, message
    }
}

struct TokenData: Codable {
    var login: String?
    var name: String?
    var token: String?
    var user_id: String?
}


