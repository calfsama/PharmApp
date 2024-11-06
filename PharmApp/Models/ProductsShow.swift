//
//  ProductsShow.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 07/10/22.
//

import Foundation

struct ProductsShow: Codable {
    var product: ProductsShowInfo?
    var similar_products: [SimilarProducts]?
//    var prods_suggestions: [ProdsSuggestions]?
    var comments: [Comments]?
    
//    enum CodingKeys: String, CodingKey {
//        case product, similar_products, comments
//    }
}

struct ProductsShowInfo: Codable {
    var id: String?
    var product_name: String?
    var product_about: String?
    var product_type: String?
    var product_form: ProductForm?
    var product_brand: ProductBrand?
    var product_country: String?
    var product_old_price: String?
    var product_price: String?
    var product_pic: String?
    var total_count_in_store: String?
//    var product_articule: String?
//    var product_of_the_day: String?
//    var product_suggestions: String?
//    var product_in_category: String?
//    var product_status: String?
//    var active_substance: [ActiveSubstance]?
    var categories: [ProductCategories]?
    var is_favorite: Bool?
//    var product_pics: [ProductPics]?
    var prod_rating_average: MyValue
//    var prod_rating_each: String?
//    var review_count: Double?
//    var product_avatar: String?
//    var meta_social_image: String?
   
   
    
//    enum CodingKeys: String, CodingKey {
//        case id, product_name, product_about, product_type, product_form, product_price
//        case product_brand, product_country, product_old_price, product_pic, categories, is_favorite, total_count_in_store, comments
//    }
    
}

struct ProdsSuggestions: Codable {
    var id: String?
    var product_name: String?
    var product_about: String?
    var product_type: String?
    var product_form: String?
    var product_brand: ProductBrand?
    var product_country: String?
    var product_old_price: String?
    var product_price: String?
    var product_pic: String?
    var total_count_in_store: String?
    var product_articule: String?
    var product_of_the_day: String?
    var product_suggestions: String?
    var product_in_category: String?
    var product_status: String?
    var prod_rating_average: Int?
    var review_count: String?
    var is_favorite: Bool?
    var base_url: String?
}

struct ProductBrand: Codable {
    var id: String?
    var brand_name: String?
}

struct ProductForm: Codable {
    var id: String?
    var form_name: String?
}

struct ActiveSubstance: Codable {
    var asp_id: String?
    var id: String?
    var tag_name: String?
}

struct ProductCategories: Codable {
    var cp_id: String?
    var id: String?
    var category_name: String?
}

struct ProductPics: Codable {
    var id: String?
    var product_id: String?
    var product_pic: String?
    var product_avatar: String?
    var base_url: String?
}

struct Comments: Codable {
    var id: String?
    var prod_id: String?
    var star_rating: String?
    var user_comment: String?
    var user_name: String?
    var status: String?
    var created_at: String?
}

struct SimilarProducts: Codable {
    var id: String?
    var product_name: String?
    var product_about: String?
    var product_type: String?
//    var product_form: ProductForm?
//    var product_brand: ProductBrand?
   // var product_country: String?
    var product_old_price: String?
    var product_price: String?
    var product_pic: String?
    var total_count_in_store: String?
//    var product_articule: String?
//    var product_of_the_day: String?
//    var product_suggestions: String?
//    var product_in_category: String?
//    var product_status: String?
//    var active_substance: [ActiveSubstance]?
//    var is_favorite: Bool?
//    var product_pics: [ProductPics]?
//    var prod_rating_average: String?
//    var prod_rating_each: String?
    var review_count: MyValue
//    var product_avatar: String?
//    var meta_social_image: String?
//    var commets: [Comments]?
//    var similar_products: SimilarProducts?
//    var prods_suggestions: [ProdsSuggestions]?
}

enum MyValue: Codable {
    case string(String)
    case int(Int)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        if let x = try? container.decode(Int.self) {
            self = .int(x)
            return
        }
        throw DecodingError.typeMismatch(MyValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for MyValue"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .string(let x):
            try container.encode(x)
        case .int(let x):
            try container.encode(x)
        }
    }
}
