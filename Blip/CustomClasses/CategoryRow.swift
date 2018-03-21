//
//  CategoryRow.swift
//  Blip
//
//  Created by Srikanth Srinivas on 2018-03-08.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Hero
import Kingfisher

class CategoryRow: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: [Item] = []
    var id: Int = 0
    var currentVC: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.register(UINib(nibName: "CustomScrollItem", bundle: nil), forCellWithReuseIdentifier: "myCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension CategoryRow: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let hardCodedPadding:CGFloat = 10
        let itemWidth = CGFloat(140)
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "myCell", for: indexPath) as! CustomScrollItem
        myCell.item = dataSource[indexPath.row]
        myCell.itemImage.kf.setImage(with: myCell.item.picture)
        myCell.itemImage.hero.id = "\(myCell.item.name)image"
        myCell.addToCartButton.hero.id = "\(myCell.item.name)button"
        myCell.nameLabel.hero.id = "\(myCell.item.name)item"
        myCell.priceLabel.hero.id = "\(myCell.item.name)price"
        myCell.nameLabel.text = myCell.item.name
        myCell.priceLabel.text = "$\(myCell.item.price!)"
        myCell.numberOfItems.text = String(myCell.cart.getCount(item: dataSource[indexPath.row]))
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CustomScrollItem
        let home = currentVC as! HomePage
        home.selectedCellImage = cell.itemImage.image!
        home.selectedCellHeroID = cell.item.name
        home.selectedCellPrice = cell.priceLabel.text
        home.selectedCellItemLabel = cell.nameLabel.text
        home.performSegue(withIdentifier: "toItem", sender: home)
    }
    
}

extension CategoryRow{
    
    func getCurrentViewController() -> UIViewController? {

        // Otherwise, we must get the root UIViewController and iterate through presented views
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            
            let currentController =  rootController as! UINavigationController
            
            return currentController.topViewController
        }
        return nil
    }
}
