//
//  ItemSearchController.swift
//  Blip
//
//  Created by Srikanth Srinivas on 2018-03-22.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Material

class ItemSearchController: SearchBarController {

    private var menuButton: IconButton!
    private var moreButton: IconButton!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(rootViewController: SearchViewController())
    }
    
    open override func prepare() {
        super.prepare()
        prepareMenuButton()
        prepareMoreButton()
        prepareStatusBar()
        prepareSearchBar()
    }
    
    private func prepareMenuButton() {
        menuButton = IconButton(image: Icon.cm.menu)
    }
    
    private func prepareMoreButton() {
        moreButton = IconButton(image: Icon.cm.moreVertical)
    }
    
    private func prepareStatusBar() {
        statusBarStyle = .lightContent
        
        // Access the statusBar.
        //        statusBar.backgroundColor = Color.grey.base
    }
    
    private func prepareSearchBar() {
        searchBar.leftViews = [menuButton]
        searchBar.rightViews = [moreButton]
    }
    
}
