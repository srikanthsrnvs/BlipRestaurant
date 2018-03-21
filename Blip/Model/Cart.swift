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
    
    private static let _shared = Cart()
    static var shared:Cart{
        return _shared
    }
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
     Adds the specified item to cart
     */
    func addToCart(item: Item){
        item.quantity = item.quantity + 1
        self.items[item.productID] = [item: item.quantity]
    }
    
    /*
     Decrease item quantity by 1
     */
    func decreaseItem(item: Item){
        if(self.items[item.productID] != nil){
            self.items[item.productID]![item]!-=1
            item.quantity = item.quantity - 1
            print("HOLLA",self.items[item.productID]![item]!)
        }
    }
    
    /*
     Increase item quantity by 1
     */
    func increaseItem(item:Item){
        self.items[item.productID]![item]!+=1
        item.quantity = item.quantity + 1
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
    
    func getCount(item: Item) -> Int{
        if self.items[item.productID] != nil{
            return self.items[item.productID]![item]!
        }
        return 0
        
    }
}

