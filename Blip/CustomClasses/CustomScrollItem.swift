//
//  CustomScrollItem.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-07.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit

class CustomScrollItem: UIView {
    @IBOutlet weak var image_one: UIImageView!
    @IBOutlet weak var categoryName_one: UILabel!
    
    @IBOutlet weak var categoryName_two: UILabel!
    @IBOutlet weak var image_two: UIImageView!
    override init(frame: CGRect){
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }


}


