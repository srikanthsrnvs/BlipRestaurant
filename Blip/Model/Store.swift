//
//  Store.swift
//  Blip
//
//  Created by Srikanth Srinivas on 3/25/18.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import Foundation
import Firebase

class Store {
    
    var name: String!
    var storeLogo: UIImage!
    var storeBackground: UIImage!
    var catalog: [String: [Item]]!
    var minOrder: Float!
    var description: String!
    
    init(name: String, storeLogo: UIImage, storeBackground: UIImage, storeCatalog: [String: [Item]], minOrder: Float, description: String) {
        
        self.minOrder = minOrder
        self.name = name
        self.storeLogo = storeLogo
        self.storeBackground = storeBackground
        self.catalog = storeCatalog
        self.description = description
    }
    
}
