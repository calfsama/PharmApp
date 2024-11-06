//
//  Sales.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 25/10/22.
//

import Foundation

struct Sales: Codable {
    var total_products: TotalProducts?
}

struct TotalProducts: Codable {
    //var pages: [Pages]?
    var total_prods: [TotalProds]?
}
struct Pages: Codable {
    
}

struct TotalProds: Codable {
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
    let prod_rating_average: MyValue
//    var review_count: String?
    var is_favorite: Bool?
//    var base_url: String?
    
    enum CodingKeys: String, CodingKey {
        case id, product_name, product_pic, product_price
        case is_favorite, prod_rating_average
    }
}
