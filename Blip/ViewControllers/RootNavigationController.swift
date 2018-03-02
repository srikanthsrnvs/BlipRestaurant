//
//  RootNavigationController.swift
//  Blip
//
//  Created by Srikanth Srinivas on 2018-03-01.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Material

class RootNavigationController: NavigationController {

    fileprivate var backButton: IconButton!
    fileprivate var cartButton: IconButton!
    var userAddress = "156 Enfield Place"
    
    open override func prepare() {
        super.prepare()
        guard let v = navigationBar as? NavigationBar else {
            return
        }
        prepareNavigationItem()
        v.depthPreset = .none
        v.dividerColor = Color.grey.lighten2
    }
    
    fileprivate func prepareNavigationItem() {
        navigationItem.titleLabel.text = "Home"
        navigationItem.detailLabel.text = "Delivering to \(userAddress)"
        
        navigationItem.leftViews = [backButton]
        navigationItem.rightViews = [cartButton]
    }

}
