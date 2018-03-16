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

class CustomScrollItem: UICollectionViewCell {
    
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var addToCartButton: IconButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.addToCartButton.layer.cornerRadius = self.addToCartButton.frame.size.height/2
        self.addToCartButton.setIcon(icon: .googleMaterialDesign(.add), color: UIColor.white, forState: .normal)
        self.addToCartButton.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        self.ApplyCornerRadiusToView()
    }


}


