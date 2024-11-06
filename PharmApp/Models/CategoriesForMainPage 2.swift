//
//  CategoriesForMainPage.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 28/09/22.
//

import Foundation

struct CategoriesForMainPage: Codable {
    var categories_for_main_page: [CategoriesForPage]?
}

struct CategoriesForPage: Codable {
    var categ: Categ?
}

struct Categ: Codable {
    var id: String?
    var category_name: String?
    var parent_id: String?
    var category_in_main: String?
    var order_id: String?
    var icon: String?
    var base_url: String?
    var total_cat_in_main: Int?
    var sub_cat: [SubCateg]?
}

struct SubCateg: Codable {
    var id: String?
    var category_name: String?
    var parent_id: String?
    var category_in_main: String?
    var order_id: String?
    var icon: String?
    var sub_cat: 
}
