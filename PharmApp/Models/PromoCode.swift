//
//  PromoCode.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 26/05/23.
//

import Foundation

struct Promocode: Codable {
    var status: Bool?
    var data: PromocodeData?
}

struct PromocodeData: Codable {
    var id: String?
    var discount: String?
    var created_at: String?
    var updated_at: String?
    var text: String?
}
