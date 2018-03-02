//
//  TestCollection.swift
//  Blip
//
//  Created by Srikanth Srinivas on 2018-03-01.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import CollectionKit
import Pastel

class TestCollection: UIViewController {

    
    @IBOutlet var gradientView: PastelView!
    @IBOutlet weak var collectionView: CollectionView!
    
    fileprivate var items = ["Gloves", "Boots", "Bindings", "Hoodie"]
    var images: [UIImage?] = []
    var userAddress = "156 Enfield Place"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradientView.prepareDefaultPastelView()
        let x = loadImages()
        collectionView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
        let provider = CollectionProvider(data: x, viewGenerator: { (data, index) -> UIImageView in
            let view = UIImageView()
            view.layer.cornerRadius = 5
            view.clipsToBounds = true
            return view
        }, viewUpdater: { (view: UIImageView, data: UIImage, at: Int) in
            view.image = data
        })
        provider.layout = WaterfallLayout(columns: 2, spacing: 20).transposed()
        provider.presenter = ZoomPresenter()
        provider.sizeProvider = imageSizeProvider
        collectionView.provider = provider
        // Do any additional setup after loading the view.
    }
    func loadImages() -> [UIImage]{
        
        for item in items{
            
            for number in 1...5{
                let image = UIImage(named: "\(item)\(number)")
                images.append(image!)
            }
            
        }
        return images as! [UIImage]
    }
    
    func prepareBackButton(){
        
        
    }
    
    func prepareCartButton(){
        
        
    }
    
    func imageSizeProvider(at: Int, data: UIImage, collectionSize: CGSize) -> CGSize {
        var imageSize = data.size
        if imageSize.width > collectionSize.width {
            imageSize.height /= imageSize.width/collectionSize.width
            imageSize.width = collectionSize.width
        }
        if imageSize.height > collectionSize.height {
            imageSize.width /= imageSize.height/collectionSize.height
            imageSize.height = collectionSize.height
        }
        return imageSize
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
