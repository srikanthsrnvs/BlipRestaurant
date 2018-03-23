//
//  ItemData.swift
//  Blip
//
//  Created by Srikanth Srinivas on 2018-03-22.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Material
import Graph

extension UIImage {
    public class func load(contentsOfFile ItemName: String, ofType type: String) -> UIImage? {
        return UIImage(contentsOfFile: Bundle.main.path(forResource: ItemName, ofType: type)!)
    }
}

struct SampleData {
    public static func createData() {
        let graph = Graph()
        
        let u1 = Entity(type: "Category")
        u1["ItemName"] = "Eggs"
        u1["Description"] = "Dairy & Pantry"

        
        let u2 = Entity(type: "Category")
        u2["ItemName"] = "Milk"
        u2["Description"] = "Dairy & Pantry"
        
        let u3 = Entity(type: "Category")
        u3["ItemName"] = "Bread"
        u3["Description"] = "Bakery"
        
        let u4 = Entity(type: "Category")
        u4["ItemName"] = "Cheese"
        u4["Description"] = "Dairy & Pantry"
        
        let u5 = Entity(type: "Category")
        u5["ItemName"] = "Banana"
        u5["Description"] = "Fruits and Vegetables"
        
        let u7 = Entity(type: "Category")
        u7["ItemName"] = "Butter"
        u7["Description"] = "Fruits and Vegetables"
        
        let u8 = Entity(type: "Category")
        u8["ItemName"] = "Onions"
        u8["Description"] = "Fruits and Vegetables"
        
        let u9 = Entity(type: "Category")
        u9["ItemName"] = "Avocados"
        u9["Description"] = "Fruits and Vegetables"
        
        graph.sync()
    }
}

