//
//  StoreTableViewCell.swift
//  Blip
//
//  Created by Srikanth Srinivas on 3/25/18.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Cosmos

class StoreTableViewCell: UITableViewCell {

    
    @IBOutlet weak var overlay: UIView!
    @IBOutlet weak var orderAmount: UILabel!
    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var storeRating: CosmosView!
    @IBOutlet weak var storeLogo: UIImageView!
    @IBOutlet weak var storeImage: UIImageView!
    
    var store: Store!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.storeLogo.layer.cornerRadius = self.storeLogo.frame.size.height/2
        storeLogo.backgroundColor = UIColor.white
        let color = UIColor.black.withAlphaComponent(0.70)
        overlay.backgroundColor = color
        storeRating.isHidden = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = UIColor.black.withAlphaComponent(0.70)
        super.setSelected(selected, animated: animated)
        
        if selected {
            storeLogo.backgroundColor = UIColor.white
            overlay.backgroundColor = color
        }
        
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        
        let color = UIColor.black.withAlphaComponent(0.70)
        super.setHighlighted(highlighted, animated: animated)
        
        if highlighted {
            storeLogo.backgroundColor = UIColor.white
            overlay.backgroundColor = color
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = UIEdgeInsetsInsetRect(contentView.frame, UIEdgeInsetsMake(0, 10, 0, 10))
    }

}
