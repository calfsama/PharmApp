//
//  Show.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 05/10/22.
//

import Foundation

struct Show: Codable {
    var blog: ShowBlog?
}

struct ShowBlog: Codable {
    var id: String?
    var blog_title: String?
    var blog_about: String?
    var blog_created_at: String?
    var order_id: String?
    var blog_pics: [BlogPics]?
    var blog_date: String?
}

struct BlogPics: Codable {
    var id: String?
    var blog_pic: String?
    var blog_avatar: String?
    var blog_id: String?
    var base_url: String?
}
