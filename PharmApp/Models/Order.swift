//
//  Order.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 19/12/22.
//

import Foundation


struct Orders: Codable {
    var status: Bool?
    var order_id: Int?
    
    enum CodingKeys: Codable, CodingKey {
        case status, order_id
    }
}
