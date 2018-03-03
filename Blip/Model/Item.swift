//
//  Item.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-01.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import Foundation
/*
    An Item has a name, price, picture, quantity and productID
 */
class Item {
    
    var name:String?
    var price: Float?
    var picture: URL?
    var quantity: Float?
    var productID: Int?
    
    init(name: String, price: Float, picUrlString: String, quantity:Float?) {
        self.name = name
        self.price = price
        self.picture = URL(string: picUrlString)
        if quantity != nil {
            self.quantity = quantity
        }
    }
}
