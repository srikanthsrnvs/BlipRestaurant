//
//  CustomCollectionViewCell.swift
//  Blip
//
//  Created by Srikanth Srinivas on 2018-03-02.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.frame.size.width = 125
    }
}
