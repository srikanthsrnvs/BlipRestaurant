//
//  RootNavigationController.swift
//  Blip
//
//  Created by Srikanth Srinivas on 3/15/18.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import  SwiftIcons

class RootNavigationController: UINavigationController {

    var stores = [Store]()

    override func viewDidLoad() {
        super.viewDidLoad()
        (self.viewControllers.first as! StoreSelectorViewController).stores = self.stores
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        
//        if segue.identifier == "toHomePage"{
//            let dest = segue.destination as! HomePage
//            dest.dataSource = datasource
//        }
//    }
    
}
