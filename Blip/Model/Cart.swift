//
//  Cart.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-01.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import Foundation

/*
     Cart dictionary of productID key and Item as value
 */
class Cart{
    

    var items:[Int:[Item:Int]] = [:]

    init() {
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
    func getTotalPrice() ->Float{
        if items.isEmpty{
            return 0.00
        }
        var total:Float = 0
        for( _ , itemdict) in items{
            for (item, quantity) in itemdict{
                total = total + (item.price! * Float(quantity))
            }
        }
        return total
    }
    
    
}
