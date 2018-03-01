//
//  ShopScreenVC.swift
//  Blip
//
//  Created by Srikanth Srinivas on 3/1/18.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import GlidingCollection
import Firebase
import Lottie
import Material

class ShopScreenVC: UIViewController {
    
    fileprivate var collectionView: UICollectionView!
    fileprivate var items = ["Gloves", "Boots", "Bindings", "Hoodie"]
    var images: [[UIImage?]] = []

    @IBOutlet var shopScrollView: GlidingCollection!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0.8495121598, blue: 0, alpha: 1)
        setup()
//        shopScrollView.backgroundColor = #colorLiteral(red: 0, green: 0.8495121598, blue: 0, alpha: 1)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

// MARK: - Setup
extension ShopScreenVC {
    
    func setup() {
        setupGlidingCollectionView()
        loadImages()
    }
    
    func loadImages(){
        
        for item in items{
            
            var imageList = [UIImage]()
            for number in 1...5{
                let image = UIImage(named: "\(item)\(number)")
                imageList.append(image!)
            }
            
            images.append(imageList)
        }
    }
    
    private func setupGlidingCollectionView() {
        shopScrollView.dataSource = self
        
        let nib = UINib(nibName: "Item", bundle: nil)
        collectionView = shopScrollView.collectionView
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = shopScrollView.backgroundColor
    }
    
}

// MARK: - CollectionView 🎛
extension ShopScreenVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = shopScrollView.expandedItemIndex
        return images[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? ItemCollectionViewCell else { return UICollectionViewCell() }
        let section = shopScrollView.expandedItemIndex
        let image = images[section][indexPath.row]
        cell.priceLabel.text = "$ 500.00"
        cell.productLabel.text = "This is a cool item"
        cell.imageView.image = image
        cell.contentView.clipsToBounds = true
        
        let layer = cell.layer
        let config = GlidingConfig.shared
        layer.shadowOffset = config.cardShadowOffset
        layer.shadowColor = config.cardShadowColor.cgColor
        layer.shadowOpacity = config.cardShadowOpacity
        layer.shadowRadius = config.cardShadowRadius
        
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let section = shopScrollView.expandedItemIndex
        let item = indexPath.item
        print("Selected item #\(item) in section #\(section)")
    }
    
}

// MARK: - Gliding Collection 🎢
extension ShopScreenVC: GlidingCollectionDatasource {
    
    func numberOfItems(in collection: GlidingCollection) -> Int {
        return items.count
    }
    
    func glidingCollection(_ collection: GlidingCollection, itemAtIndex index: Int) -> String {
        return "– " + items[index]
    }
}
