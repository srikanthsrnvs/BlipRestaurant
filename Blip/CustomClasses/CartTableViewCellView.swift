//
//  CartTableVIewCellView.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-09.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import GMStepper

class CartTableViewCellView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var itemName: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var stepper: GMStepper!
    var item: Item!
    var cart = Cart.shared
    var tableview:UITableView!
    var initial_value_when_loaded: Int!
    
//    override func awakeFromNib() {
////        self.initial_value_when_loaded
//        self.stepper.value = Double(self.initial_value_when_loaded)
//        print(stepper.value)
//    }

    @IBAction func stepperChanged(_ sender: GMStepper){
        print("init val", initial_value_when_loaded)
        if Int(sender.value) < initial_value_when_loaded{ //Checking to see if stepper was decreased
            cart.decreaseItem(item: self.item)
            print("Decreased item quantity")
        }
        if Int(sender.value) > initial_value_when_loaded{ //Checking to see if stepper was increased
            cart.increaseItem(item: self.item)
            print("Increased item quantity")
        }

        let price = self.item.price!
        self.price.text = "$\(price * sender.value)"
        cart.items[self.item.productID]![self.item]! = Int(sender.value)
        self.initial_value_when_loaded = Int(sender.value)
        print(cart.items)
    }
    
//    @IBAction func stepperPressed(_ sender: UIStepper) {
//        
//        var initial_quantity_num = Double(self.quantityLabel.text!)!
//        if sender.value < initial_quantity_num{ //Checking to see if stepper was decreased
//            cart.decreaseItem(item: self.item)
//        }
//        if sender.value > initial_quantity_num{ //Checking to see if stepper was increased
//            cart.increaseItem(item: self.item)
//        }
//        self.quantityLabel.text = "\(Int(sender.value))"
//        initial_quantity_num = Double(self.quantityLabel.text!)!
//        let price = self.item.price!
//        self.price.text = "$\(price * initial_quantity_num)"
//        cart.items[self.item.productID]![self.item]! = Int(initial_quantity_num)
//    }
    
    @IBAction func deleteItemPresssed(_ sender: UIButton){
        self.item.quantity = 0
        cart.items[self.item.productID] = nil
        //Deletes item with animation
        UIView.transition(with: self.tableview, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.tableview.reloadData()
        }, completion: nil)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
