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
    

    var items:[Int:Item] = [:]
    
    init() {
        
    }
    /*
        Remove the specified Item from the Cart
     */
    func removeItem(item: Item){
        self.items[item.productID!] = nil
    }
}
