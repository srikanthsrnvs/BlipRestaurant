//
//  RootNavigationController.swift
//  Blip
//
//  Created by Srikanth Srinivas on 3/15/18.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {

    var datasource: [String: [Item]] = [:]
    var categories = ["FRUITS AND VEGETABLES", "NATURAL AND ORGANIC", "DELI AND READY-MEALS"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.viewControllers.first as! HomePage).dataSource = datasource
        print(datasource)
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
