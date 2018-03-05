//
//  RootNavigationController.swift
//  Blip
//
//  Created by Srikanth Srinivas on 2018-03-01.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Material
import SwiftIcons

class RootNavigationController: ToolbarController {

    fileprivate var profileButton: IconButton!
    fileprivate var cartButton: IconButton!
    
    open override func prepare() {
        super.prepare()
        prepareBackButton()
        prepareStarButton()
        prepareStatusBar()
        prepareToolbar()
    }
}

fileprivate extension RootNavigationController {
    func prepareBackButton() {
        profileButton = IconButton(title: "")
        profileButton.tintColor = UIColor.white
        profileButton.setIcon(icon: .googleMaterialDesign(.face), iconSize: 25, color: UIColor.white, forState: .normal)
        profileButton.pulseColor = .white
    }
    
    func prepareStarButton() {
        cartButton = IconButton(title: "")
        cartButton.tintColor = UIColor.white
        cartButton.setIcon(icon: .googleMaterialDesign(.shoppingCart), iconSize: 25, color: UIColor.white, forState: .normal)
        cartButton.pulseColor = .white
    }
    
    
    func prepareStatusBar() {
        statusBarStyle = .default
        statusBar.backgroundColor = #colorLiteral(red: 0, green: 0.8495121598, blue: 0, alpha: 1)
    }
     
    func prepareToolbar() {

        toolbar.backgroundColor = #colorLiteral(red: 0, green: 0.8495121598, blue: 0, alpha: 1)
        toolbar.leftViews = [profileButton]
        toolbar.rightViews = [cartButton]
    }
}

