//
//  LoblawsResponse.swift
//  Scraping
//
//  Created by Gbenga Ayobami on 2018-03-10.
//  Copyright © 2018 Gbenga Ayobami. All rights reserved.
//

import Foundation
import SwiftSoup

enum HTMLError: Error{
    case badInnerHTML
}
struct LoblawsResponse {
    var items:[Item] = []
    init(innerHTML: Any?) throws {
        
        guard let htmlString = innerHTML as? String
            else{throw HTMLError.badInnerHTML}
        
        let doc = try SwiftSoup.parse(htmlString)
        let names = try doc.getElementsByClass("product-name").array()
        let prices = try doc.getElementsByClass("reg-price-text").array()
        let images = try doc.getElementsByClass("product-image ").array()
        
        for i in 0..<names.count{
            let name = try names[i].text()
            
            let priceStr = try prices[i].text()
            var priceArr = priceStr.components(separatedBy: "$")
            let price = Double(priceArr.removeLast())
            
            let imageWithProductid = String(describing: images[i].child(0)).components(separatedBy: "src=")[1]
            let image = imageWithProductid.components(separatedBy: "\"")[1]
            let productId = Int(image.components(separatedBy: "/")[4])
            let item = Item(name: name, price: price!, picUrlString: image, productID: productId!, quantity: nil)
            self.items.append(item)
            print(self.items)
//            print(name)
//            print(price)
//            print(productId)
//            print(image)
//            print(" ")
        }
//        print(names.count)
    }
}
