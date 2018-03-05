//
//  ViewController.swift
//  Blip
//
//  Created by Srikanth Srinivas on 3/1/18.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Lottie
import Pastel
import SpriteKit

class OnboardingVC: UIViewController {

    @IBOutlet var gradientView: PastelView!
    fileprivate var items = ["Gloves", "Boots", "Bindings", "Hoodie"]
    var images = [UIImage]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientView.prepareDefaultPastelView()
        gradientView.startAnimation()
        loadImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gradientView.startAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gradientView.startAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImages(){
        
        for item in items{
            
            for number in 1...5{
                let image = UIImage(named: "\(item)\(number)")
                images.append(image!)
            }
            
        }
    }

}

