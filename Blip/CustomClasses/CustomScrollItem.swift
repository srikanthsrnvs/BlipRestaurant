//
//  CustomScrollItem.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-07.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Material
import SwiftIcons
import FontAwesome_swift
import Lottie

class CustomScrollItem: UICollectionViewCell {
    
    @IBOutlet weak var numberOfItems: UILabel!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCartButton: RaisedButton!
    @IBOutlet weak var nameLabel: UILabel!
    var item:Item!
    var cart = Cart.shared
    var addAnimation = LOTAnimationView(name: "addToCart")
    var count = 0
    
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        prepareAddToCartButton()
        prepareNumberOfItems()
    }

    @IBAction func addToCartPressed(_ sender: Any) {
        
        self.cart.addToCart(item: self.item)
        print(cart.items)
        addAnimation.play()
        count += 1
        numberOfItems.text = String(count)
    }
    
    
    func prepareAddToCartButton(){
        
        let addAnimationView = UIView(frame: CGRect(x: 0, y: 0, width: addToCartButton.frame
            .size.height, height: addToCartButton.frame
        .size.height))
        addAnimationView.backgroundColor = #colorLiteral(red: 0.4658077359, green: 0.7660514712, blue: 0.2661468089, alpha: 1)
        addAnimationView.layer.cornerRadius = 22
        addAnimationView.handledAnimation(Animation: addAnimation, width: 1.6, height: 1.6)
        addAnimation.animationSpeed = 2
        addAnimationView.isUserInteractionEnabled = false
        self.addToCartButton.addSubview(addAnimationView)
    }
    
    func prepareNumberOfItems(){
        
        numberOfItems.layer.cornerRadius = numberOfItems.frame.size.height/2
        numberOfItems.text = String(count)
        numberOfItems.layer.masksToBounds = true
    }

    override func prepareForReuse() {
        
        numberOfItems.text = "0"
        count = 0
        item = nil
        itemImage.image = nil
    }
}


