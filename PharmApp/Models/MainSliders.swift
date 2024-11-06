//
//  MainSliders.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 29/09/22.
//

import Foundation

struct MainSliders: Codable {
    var main_slider: [Main_Sliders]?
}

struct Main_Sliders: Codable {
    var slider_id: String?
    var slider_name: String?
    var slider_link: String?
    var slider_pic: String?
//    var slider_enabled: String?
//    var slider_type: String?
//    var slider_category_id: String?
//    var order_id: String?
//    var type: String?
//    var id: String?
//    var category_name: String?
//    var parent_id: String?
//    var category_in_main: String?
//    var icon: String?
//    var base_url: String?
    
    enum CodingKeys: String, CodingKey {
        case slider_id, slider_name, slider_link, slider_pic
    }
    var formatedImage: String {
        let image = slider_pic?.replacingOccurrences(of: "\\", with: "", options: NSString.CompareOptions.literal, range: nil)
        return image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
