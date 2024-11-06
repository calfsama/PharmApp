//
//  Blog.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 29/09/22.
//

import Foundation

struct Blog: Codable {
    var base_url: String?
   // var tags: [Tags]?
    var title: String?
    var content: Content?
}

struct Tags: Codable {
    var id: String?
    var tags_name: String?
    var base_url: String?
}

struct Content: Codable {
    var blogs: [Blogs]?
}

struct Blogs: Codable {
    var id: String?
    var blog_title: String?
    var blog_about: String?
    var blog_created_at: String?
    var order_id: String?
    var base_url: String?
    var blog_pic: String?
    
    enum CodingKeys: String, CodingKey {
        case id, blog_title, blog_about
        case blog_created_at, order_id
        case base_url, blog_pic
    }
}
