//
//  Categories.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 29/09/22.
//

import Foundation

struct Category: Codable {
    var categories: [SubCategories]?
}

struct SubCategories: Codable {
    var id: String?
    var category_name: String?
    var parent_id: String?
    var category_in_main: String?
    var order_id: String?
    var icon: String?
    var base_url: String?
    var total_cat_in_main: Int?
    var sub_cat: [SubCat]?
    
}
struct SubCat: Codable {
    var id: String?
    var category_name: String?
    var parent_id: String?
    var category_in_main: String?
    var order_id: String?
    var icon: String?
    var sub_cat: [SubCategory]?
    
    enum CodingKeys: String, CodingKey {
        case id, category_name, parent_id, category_in_main
        case order_id, icon, sub_cat
    }
}

struct SubCategory: Codable {
    var id: String?
    var category_name: String?
    var parent_id: String?
    var category_in_main: String?
    var order_id: String?
    var icon: String?
    
  
}
