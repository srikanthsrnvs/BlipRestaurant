//
//  ItemViewController.swift
//  Blip
//
//  Created by Srikanth Srinivas on 2018-03-14.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Hero
import Material
import Firebase
import SwiftIcons

class ItemViewController: UIViewController {

    @IBOutlet weak var itemImage: UIImageView!
    
    var itemImageVariable: UIImage!
    var heroIdentifier: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemImage.image = itemImageVariable
        itemImage.hero.id = heroIdentifier
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
