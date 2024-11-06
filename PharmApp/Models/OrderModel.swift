//
//  OrderModel.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 21/12/22.
//

import Foundation

struct OrderModel: Codable {
    var order: OrderData?
    var status: [OrderStatus]
    var delivery: [OrderDelivery]
    var products: [OrderProduct]
    
    enum CodingKeys: String, CodingKey {
        case order, status, delivery, products
    }
}

struct OrderData: Codable {
    var id: String?
    var user_id: String?
    var order_id: String?
    var previous_status_id: String?
    var status_id: String?
    var user_comment: String?
    var created_at: String?
    var phone_number: String?
    var full_name: String?
    var address: String?
    var comment: String?
    var cash_type: String?
    var code: String?
    var hash: String?
    var export: String?
    var wallet_name: String?
    var transaction_id: String?
    var paid_date: String?
    var delivery_type: String?
    var total_price: String?
}

struct OrderStatus: Codable {
    var status_text: String?
}

struct OrderDelivery: Codable {
    var delivery_price: String?
}

struct OrderProduct: Codable {
    var id: String?
    var product_id: String?
    var order_id: String?
    var total_count: String?
    var product_sold_price: String?
    var product_name: String?
    var product_about: String?
    var product_type: String?
    var product_form: String?
    var product_brand: String?
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
}

typealias OrdersData = [OrderModel]
