//
//  CategoriesProducts.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 29/12/22.
//

import Foundation

struct CategoriesProducts: Codable {
    var category_id: String?
    //var page: Int?
    var total_products: String?
    var category_with_parents: CategoryWithParents?
    var category: ProductCategory?
    var category_products: CategoryProduct?
    
    enum CodingKeys: String, CodingKey {
        case category_id, total_products
        case category_with_parents, category, category_products
    }
}

struct CategoryWithParents: Codable {
    var id: String?
    var category_name: String?
    var parent_id: String?
    var category_in_main: String?
    var order_id: String?
    var icon: String?
    var base_url: String?
    var parent_cat: ParentCat?
}

struct ParentCat: Codable {
    var id: String?
    var category_name: String?
    var parent_id: String?
    var category_in_main: String?
    var order_id: String?
    var icon: String?
}

struct ProductCategory: Codable {
    var id: String?
    var category_name: String?
    var parent_id: String?
    var category_in_main: String?
    var order_id: String?
    var icon: String?
    var base_url: String?
    var sub_cat: [Sub_Category]
    
}

struct Sub_Category: Codable {
    var id: String?
    var category_name: String?
    var parent_id: String?
    var category_in_main: String?
    var order_id: String?
    var icon: String?
    var sub_cat: [Sub_Categ]
}

struct Sub_Categ: Codable {
    
}

struct CategoryProduct: Codable {
    var pages: [Page]
    var next_page: Int?
    var products: [ShowProducts]
}

struct Page: Codable {
    var page: Int?
    var current_page: String?
    var total_pages: Int?
    var base_url: String?
    var link: String?
    var current: String?
}

struct ShowProducts: Codable {
    var id: String?
    var product_name: String?
    var product_about: String?
    var product_type: String?
//    var product_form: ProductForm?
//    var product_brand: ProductBrand?
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
//    var review_count: Int?
//    var product_avatar: String?
//    var meta_social_image: String?
//    var commets: [Comments]?
    var similar_products: SimilarProducts?
//    var prods_suggestions: [ProdsSuggestions]?
}
