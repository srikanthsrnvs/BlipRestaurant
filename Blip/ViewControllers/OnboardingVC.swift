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
import Firebase

class OnboardingVC: UIViewController {

    @IBOutlet var gradientView: PastelView!
    
    var dbRef:DatabaseReference!
    var datasource: [String: [Item]] = [:]
    var categories = ["FRUITS AND VEGETABLES", "NATURAL AND ORGANIC", "DELI AND READY-MEALS"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = Database.database().reference()
        gradientView.prepareDefaultPastelView()
        gradientView.startAnimation()
//        loadItemsFromFirebase()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toStoreSelector"{

            let dest = segue.destination as! RootTabBarController
            let walmart = Store(name: "Walmart", storeLogo: UIImage(named: "walmartLogo")!, storeBackground: UIImage(named: "walmart")!, storeCatalog: self.datasource, minOrder: 20.00, description: "What started small, with a single discount store and the simple idea of selling more for less, has grown over the last 50 years into the largest retailer in the world. Each week, over 260 million customers and members visit our 11,695 stores under 59 banners in 28 countries and e-commerce websites in 11 countries.")
            let freshcoStore = Store(name: "Freshco", storeLogo: UIImage(named: "freshcoLogo")!, storeBackground: UIImage(named: "freshco")!, storeCatalog: self.datasource, minOrder: 30.00, description: "FreshCo. is the discount banner of Sobeys Incorporated (a 100% Canadian owned company established in 1907). Launched in 2010, FreshCo's commitment is to provide the best discount grocery shopping experience by offering quality fresh food at low prices and with less compromise")
            let loblawsStore = Store(name: "Loblaws", storeLogo: UIImage(named: "loblawsLogo")!, storeBackground: UIImage(named: "loblaws")!, storeCatalog: self.datasource, minOrder: 35.00, description: "Loblaw Companies Limited. Canada's food and pharmacy leader, with a network of corporate and independently- operated stores in communities across the country, and employing close to 200,000 Canadians. Loblaw's purpose – Live Life Well")
            dest.stores = [walmart, loblawsStore, freshcoStore]
        }
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
    @IBAction func getStartedPressed(_ sender: Any) {
        
        loadItemsFromFirebase {
            self.performSegue(withIdentifier: "toStoreSelector", sender: nil)
        }
        
        
    }
    
    func loadItemsFromFirebase(completion: @escaping ()->()){
        
        let itemsRef = dbRef.child("items")
        itemsRef.observeSingleEvent(of: .value) { (snapshot) in
            let cateDict = snapshot.value as! [String:AnyObject] //Contains category names as keys
            for (cate, val) in cateDict{
                self.datasource[cate] = []
                let idDict = val as! [String:AnyObject] //Contains productIDs as keys
                for (proID, itemVals) in idDict{
                    let productID = proID
                    let values = itemVals as! [String:AnyObject]
                    let name = values["name"] as! String
                    let picUrlStr = values["photoUrl"] as! String
                    let price = values["price"] as! Double
                    let item = Item(name: name, price: price, picUrlString: picUrlStr, productID: productID)
                    self.datasource[cate]?.append(item)
                }
            }
            completion()
        }
//        for category in categories{
//
//            itemsRef.child(category).observe(.value, with: { (snapshot) in
//                let itemValues = snapshot.value as! [String:AnyObject]
//                self.datasource[category] = []
//                for (key, val) in itemValues{
//                    let productID = Int(key)
//                    let values = val as! [String:AnyObject]
//                    let name = values["name"] as! String
//                    let picUrlStr = values["photoUrl"] as! String
//                    let price = values["price"] as! Double
//                    let item = Item(name: name, price: price, picUrlString: picUrlStr, productID: productID!)
//                    self.datasource[category]?.append(item)
//                }
//                completion()
//            })
//
////            itemsRef.child(category).observe(.childAdded, with: { (snapshot) in
////                let item = Item(snapshot: snapshot)
////                self.datasource[category] = []
////                self.datasource[category]?.append(item!)
////                completion()
////            })
////            itemsRef.child(category).observeSingleEvent(of: .childAdded, with: { (snapshot) in
////
////                let item = Item(snapshot: snapshot)
////                self.datasource[category]?.append(item!)
////                print(snapshot.key)
////            })
//        }
    }
    
}

