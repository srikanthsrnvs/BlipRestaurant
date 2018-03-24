
//  CartVC.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-09.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Firebase
import Stripe
import SwiftIcons

class CartVC: UIViewController{
    
    

    var dbRef:DatabaseReference!
    @IBOutlet weak var checkoutButtonLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var checkoutButton: UIButton!
    var cart = Cart.shared
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.checkoutButton.addTarget(self, action: #selector(checkout), for: .touchUpInside)
        // Do any additional setup after loading the view.
        dbRef = Database.database().reference()
        prepareCloseButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        self.loadCategories()
//        self.uploadToFirebase()
//        self.loadItemsByCategory()
    }
    
    func prepareCloseButton(){
        
        closeButton.setIcon(icon: .googleMaterialDesign(.close), iconSize: 35, color: UIColor.black, backgroundColor: UIColor.clear, forState: .normal)
    }
    
    @IBAction func closeCart(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func checkout(){
        //TO-DO
    }
    
//    func loadItemsByCategory(){
//        let itemsRef = dbRef.child("itemsLinks")
//        for cate in categoriesStrings{
//            itemsRef.child(cate).observeSingleEvent(of: .value, with: { (snap) in
//                let val = snap.value as! [String:AnyObject]
//                for (key, http) in val{
//                    guard let myURL = URL(string: http as! String) else {
//                        print("Error: \(http) doesn't seem to be a valid URL")
//                        return
//                    }
//                    do{
//                        let myHTMLString = try String(contentsOf: myURL, encoding: .ascii)
//                        let response = try LoblawsResponse(innerHTML: myHTMLString)
//                        self.itemsByCategory[cate] = response.items
//                    }catch let err as NSError{
//                        print(err.localizedDescription)
//                    }
//                }
//                print(self.itemsByCategory)
//            })
//
//        }
//    }
    
//    func loadCategories(){
//        let fileURLProject = Bundle.main.path(forResource: "categories", ofType: "txt")
//        var content = ""
//        do{
//            content = try String(contentsOfFile: fileURLProject!, encoding: String.Encoding.utf8)
//        }catch let err as NSError{
//            print(err)
//            return
//        }
//
//        //set the categories object
//        for cate in categoriesStrings{
//            categories.append(Category(name: cate))
//        }
//
//        let cateLinks = content.components(separatedBy: "-newCategory\n")
//        for cate in cateLinks{
//            var subs = cate.components(separatedBy: "\n")
//            subs.removeLast()
//            for sub in subs{
//                self.categories = attachLinks(categories: self.categories, str: sub)
//                //                print("PRINTING FROM SUB",self.categories)
//            }
//        }
//    }
//
//    func attachLinks(categories:[Category], str: String) -> [Category]{
//        var catCpy = categories
//        var stringArr = str.components(separatedBy: "\\")
//        for cate in catCpy{
//            if stringArr[0] == cate.name{
//                cate.links.append(stringArr[3])
//                //                print("PRINTING INSIDE ATTACHLINKS",catCpy)
//                return catCpy
//            }
//        }
//        return catCpy
//    }
//
//    func uploadToFirebase(){
//        let itemsRef = dbRef.child("itemsLinks")
//        for cate in categories{
//            for lnk in cate.links{
//                itemsRef.child(cate.name).childByAutoId().setValue(lnk)
//            }
//        }
//    }
}


extension CartVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if cart.items.count == 0{
            checkoutButton.alpha = 0
            totalLabel.alpha = 0
        }
        else{
            checkoutButton.alpha = 1
            totalLabel.alpha = 1
        }
        return cart.items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemRowCell", for: indexPath) as! ItemRow
        cell.cellView.tableview = self.tableView
        let itemsInCart = Array(Cart.shared.items.keys)
        let itemDict = self.cart.items[itemsInCart[indexPath.row]]!
        let item = (Array(itemDict.keys).first)! //Should be an array containing just one Item element
        cell.cellView.item = item
        cell.cellView.initial_value_when_loaded = cell.cellView.item.quantity
        cell.cellView.stepper.value = Double(cell.cellView.item.quantity)
        cell.cellView.itemName.text = cell.cellView.item.name
        cell.cellView.imageView.kf.setImage(with: cell.cellView.item.picture)
//        cell.cellView.quantityLabel.text = "\(cell.cellView.item.quantity!)"
        cell.cellView.price.text = "$\((cell.cellView.item.price)! * Double(cell.cellView.item.quantity))"
        return cell
    }
    
}
