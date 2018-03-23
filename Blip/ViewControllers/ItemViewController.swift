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
import GMStepper

class ItemViewController: UIViewController {

    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var addToCartButton: RaisedButton!
    @IBOutlet weak var stepper: GMStepper!
    @IBOutlet weak var closeButton: UIButton!
    
    var item: Item!
    var cart = Cart.shared
    
//    var itemImageVariable: UIImage!
//    var price: String!
//    var itemDescription: String!
    
//    var heroIdentifierForImage: String!
//    var heroIdentifierForPrice: String!
//    var heroIdentifierForItemLabel: String!
    var heroIdentifierForButton: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCloseButton()
        prepareImage()
        prepareItemLabel()
        preparePriceLabel()
        prepareAddToCartButton()
        prepareStepper()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        self.navigationController?.navigationBar.isHidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prepareImage(){
        itemImage.kf.setImage(with: self.item.picture)
        itemImage.hero.id = "\(self.item.name)image"
        
//        itemImage.image = itemImageVariable
//        itemImage.hero.id = heroIdentifierForImage
    }
    
    func preparePriceLabel(){
        
        self.priceLabel.text = "$\(self.item.price!)"
        priceLabel.hero.id = "\(self.item.name)price"
        
//        self.priceLabel.text = price
//        priceLabel.hero.id = heroIdentifierForPrice
    }
    
    func prepareItemLabel(){
        itemLabel.text = self.item.name
        itemLabel.hero.id = "\(self.item.name)item"
        
//        itemLabel.text = itemDescription
//        itemLabel.hero.id = heroIdentifierForItemLabel
    }
    
    func prepareAddToCartButton(){
        
        let cartImage = UIImage(icon: .googleMaterialDesign(.addShoppingCart), size: CGSize(width: 35, height: 35)).withRenderingMode(.alwaysTemplate)
        addToCartButton.setImage(cartImage, for: .normal)
        addToCartButton.hero.id = heroIdentifierForButton
        addToCartButton.addTarget(self, action: #selector(addToCartPressed(_:)), for: .touchUpInside)
    }
    
    @objc func addToCartPressed(_ sender: RaisedButton){
        cart.addToCartWithQuantity(item: self.item, quantity: Int(self.stepper.value))
        print(cart.items)
    }
    
    func prepareStepper(){
        stepper.hero.id = heroIdentifierForButton
        if self.item.quantity != 0{
            self.stepper.value = Double(self.item.quantity)
        }
        
    }
    
    func prepareCloseButton(){
        
        closeButton.setIcon(icon: .googleMaterialDesign(.close), iconSize: 35, color: UIColor.black, backgroundColor: UIColor.clear, forState: .normal)
    }

    @IBAction func closeView(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
}
