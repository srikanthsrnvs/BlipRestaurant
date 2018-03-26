//
//  HomePage.swift
//  Blip
//
//  Created by Srikanth Srinivas on 3/4/18.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Material
import Hero
import GooglePlaces
import PopupDialog
import SwiftIcons
import Firebase

class HomePage: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableHeader: UIView!
    @IBOutlet weak var stretchyTableHeader: StretchyTableHeader!
    
    var store: Store!
    var headerView: UIView!
    var navAlphaComponent = CGFloat(0)
    var dataSource: [String: [Item]] = [:]
    var userAddress: String?
    let locationManager = CLLocationManager()
    let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    let itemsPerRow: CGFloat = 2
    var selectedItem: Item!
    var headerViewHeight: CGFloat!
    var dbRef:DatabaseReference!
    var ind: Int!
    var cart = Cart.shared
    var numOfHomeAppearance = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ind = 0
        dbRef = Database.database().reference()
        prepareTableView()
        prepareSearch()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        numOfHomeAppearance = numOfHomeAppearance + 1
        reloadCollectionCellsToCorrectNum()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toItem"{
            let dest = segue.destination as! ItemViewController
            dest.item = self.selectedItem
            dest.heroIdentifierForButton = "\(self.selectedItem.name)button"
        }
    }
    
    func prepareSearch(){
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func prepareTableView(){
        self.navigationController?.navigationBar.isHidden = true
        self.stretchyTableHeader.overlay.hero.id = store.name
        self.stretchyTableHeader.storeLogo.image = store.storeLogo
        self.stretchyTableHeader.storeImage.image = store.storeBackground
        self.stretchyTableHeader.storeLogo.hero.id = "\(store.storeLogo)"
        self.stretchyTableHeader.storeImage.hero.id = "\(store.storeBackground)"
        self.stretchyTableHeader.storeLogo.layer.cornerRadius = self.stretchyTableHeader.storeLogo.frame.size.width/2
    }
    
    /*
     This is for the number on each collectioncell to change to appropiate number of quantity in cart
     */
    func reloadCollectionCellsToCorrectNum(){
        for i in 0 ..< dataSource.count{
            let tableViewCell = (self.tableView.cellForRow(at: IndexPath(row: 0, section: i)) as? CategoryRow)
            if tableViewCell != nil{
                tableViewCell?.collectionView.reloadData()
            }else{
                // This is because the system thinks the rest of the section is nil cuz it hasnt been
                // loaded to the screen yet
                break
            }
        }
    }
}

extension HomePage: UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        closeCurrentStore()
    }
    
    func closeCurrentStore(){
        
        if tableView.contentOffset.y < -150{
            
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension HomePage: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
    
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let categoryArray = Array(dataSource.keys)
        return categoryArray[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 240
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryRow
        cell.currentVC = self
        let categoryArray = Array(dataSource.keys)
        if(ind < categoryArray.count){
            print(categoryArray[ind])
            cell.dataSource = self.dataSource[categoryArray[ind]]!
            ind = ind + 1
        }
        return cell
    }

}




