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
        
        if segue.identifier == "toHomePage"{
            let dest = segue.destination as! RootTabBarController
            dest.datasource = datasource
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
            self.performSegue(withIdentifier: "toHomePage", sender: nil)
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

