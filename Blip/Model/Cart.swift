//
//  Cart.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-01.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import Foundation
import Firebase

/*
 Singleton class Cart which has a dictionary of productID key and Item as value
 */
class Cart{
    
    private static let shared = Cart()
    var items:[Int:[Item:Int]] = [:]
    private init() {
        //Do some firebase calls to get all items in user's cart
        
    }
    /*
     Remove the specified Item from the Cart
     */
    func removeItem(item: Item){
        self.items[item.productID!] = nil
    }
    
    /*
     Return the total price of the cart
     */
    func getTotalPrice() ->Double{
        if items.isEmpty{
            return 0.00
        }
        var total:Double = 0
        for( _ , itemdict) in items{
            for (item, quantity) in itemdict{
                total = total + (item.price! * Double(quantity))
            }
        }
        return total
    }
    
}

