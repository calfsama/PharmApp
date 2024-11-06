//
//  TabBarItem.swift
//  Salomat
//
//  Created by Tomiris Negmatova on 01/12/22.
//

import UIKit

class TabBarItem: UITabBarItem {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if let image = image {
            self.image = image.withRenderingMode(.alwaysOriginal)
        }
        if let image = selectedImage {
            selectedImage = image.withRenderingMode(.alwaysOriginal)
        }
       // setup()
    }
    
    
    func setup() {
        if let image = image {
            self.image = image.withRenderingMode(.alwaysOriginal)
        }
        if let image=selectedImage {
            selectedImage = image.withRenderingMode(.alwaysOriginal)
        }
    }
}
