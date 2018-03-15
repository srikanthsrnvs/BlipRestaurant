//
//  CategoryRow.swift
//  Blip
//
//  Created by Srikanth Srinivas on 2018-03-08.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Hero

class CategoryRow: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: [UIImage] = []
    var id: Int = 0
    
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
        
        let itemsPerRow:CGFloat = 4
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
        myCell.categoryImage.image = dataSource[indexPath.row]
        myCell.categoryImage.hero.id = String(self.id)
        self.id += 1
        return myCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! CustomScrollItem
        print(cell.categoryImage.image)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let home = getCurrentViewController() as! HomePage
        home.selectedCellImage = cell.categoryImage.image!
        home.selectedCellHeroID = cell.categoryImage.hero.id!
        home.performSegue(withIdentifier: "toItem", sender: home)
    }
}

extension CategoryRow{
    
    func getCurrentViewController() -> UIViewController? {

        // Otherwise, we must get the root UIViewController and iterate through presented views
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            
            var currentController: UIViewController! = rootController
            
            let navController = currentController.childViewControllers[0] as! UINavigationController
            return navController.topViewController
        }
        return nil
    }
}
