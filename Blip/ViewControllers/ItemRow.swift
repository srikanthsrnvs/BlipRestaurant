//
//  ItemRow.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-09.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit

class ItemRow: UITableViewCell {

    @IBOutlet weak var cellView: CartTableViewCellView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
