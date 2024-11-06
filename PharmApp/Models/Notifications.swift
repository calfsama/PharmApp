//
//  Notifications.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 19/01/23.
//

import Foundation

struct Notif: Codable {
    var id: String?
    var title: String?
    var body: String?
    var image: String?
    var type: String?
    
    enum CodingKeys: String, CodingKey {
        case id, title, body
        case image, type
    }
}

typealias NotificationData = [Notif]
