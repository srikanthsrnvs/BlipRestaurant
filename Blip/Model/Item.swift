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
class Item: Hashable {
    
    var name:String?
    var price: Double?
    var picture: URL?
    var quantity: Float?
    var productID: Int?
    
    var hashValue: Int{
        return (productID?.hashValue)!
    }
    
    init(name: String, price: Double, picUrlString: String, productID: Int, quantity:Float?) {
        self.name = name
        self.price = price
        self.picture = URL(string: picUrlString)
        self.productID = productID
        if quantity != nil {
            self.quantity = quantity
        }
    }
    
    /*
     Adds this item to the specified cart
     */
    func addToCart(quantity: Int, cart: Cart){
        cart.items[self.productID!] = [self:quantity]
    }
    
}

extension Item: Equatable {
    static func ==(lhs: Item, rhs: Item) -> Bool {
        return lhs.productID == rhs.productID
    }
}

