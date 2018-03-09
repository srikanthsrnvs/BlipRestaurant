//
//  CartTableVIewCellView.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-09.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit

class CartTableViewCellView: UIView {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var itemName: UILabel!
    @IBOutlet var price: UILabel!
    @IBOutlet var quantity:UILabel!
    
    
    
    @IBAction func stepperPressed(_ sender: UIStepper) {
        self.quantity.text = "\(Int(sender.value))"
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
