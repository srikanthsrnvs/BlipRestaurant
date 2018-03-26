//
//  RootTabBarController.swift
//  Blip
//
//  Created by Srikanth Srinivas on 2018-03-21.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit

class RootTabBarController: UITabBarController {

    var stores = [Store]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for vc in self.viewControllers!{
            if vc is RootNavigationController{
                let navController = vc as! RootNavigationController
                navController.stores = self.stores
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}
