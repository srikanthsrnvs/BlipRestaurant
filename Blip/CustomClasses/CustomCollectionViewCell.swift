//
//  CustomCollectionViewCell.swift
//  Blip
//
//  Created by Srikanth Srinivas on 2018-03-02.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import SwiftIcons
import Material
import Hero

class CustomCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var addToCartButton: IconButton!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellPrice: UILabel!
    
    func prepareBorder(){
        
        self.contentView.ApplyCornerRadiusToView()
        self.addToCartButton.tintColor = UIColor.white
        self.addToCartButton.image = Icon.cm.add
        self.addToCartButton.layer.cornerRadius = 12.5
    }
}
