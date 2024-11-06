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
    var categ_slider: [Slider]?
    var categ_prods: [Product]?
    
    enum CodingKeys: String, CodingKey {
        case categ, categ_prods, categ_slider
    }
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

struct Slider: Codable {
    var slider_id: String?
    var slider_name: String?
    var slider_link: String?
    var slider_pic: String?
    var slider_enable: String?
    var slider_type: String?
    var slider_category_id: String?
    var order_id: String?
    var type: String?
    var base_url: String?
}

struct SubCateg: Codable {
    var id: String?
    var category_name: String?
    var parent_id: String?
    var category_in_main: String?
    var order_id: String?
    var icon: String?
    var sub_cat: [Sub_Cat]?
   
}

struct Sub_Cat: Codable {
    var id: String?
    var category_name: String?
    var parent_id: String?
    var category_in_main: String?
    var order_id: String?
    var icon: String?
}

struct Product: Codable {
    var id: String?
    var product_name: String?
//    var product_about: String?
//    var product_type: String?
//    var product_form: String?
//    var product_brand: String?
//    var product_country: String?
//    var product_old_price: String?
    var product_price: String?
    var product_pic: String?
    var total_count_in_store: String?
//    var product_of_the_day: String?
//    var product_suggestions: String?
//    var product_in_category: String?
//    var product_status: String?
    var prod_rating_average: MyValue
//    var review_count: String?
    var is_favorite: Bool?
//    var base_url: String?
    
//    enum CodingKeys: String, CodingKey {
//        case id, product_name, product_pic, product_price
//        case is_favorite
//    }
}
