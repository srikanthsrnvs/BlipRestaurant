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

class OnboardingVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var gradientView: PastelView!
    fileprivate var items = ["Gloves", "Boots", "Bindings", "Hoodie"]
    var images = [UIImage]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.setNeedsLayout()
        self.collectionView.layoutIfNeeded()
        gradientView.prepareDefaultPastelView()
        gradientView.startAnimation()
        loadImages()
        setupCollectionView()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
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
    
    func setupCollectionView(){
        
        UIView.animate(withDuration: 10) {
            
            let point = CGPoint(x: 0, y: self.collectionView.contentSize.height)
            print(point.y)
            self.collectionView.setContentOffset(point, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CustomCollectionViewCell
        cell.imgView.frame.size.width = (self.collectionView.frame.width / 2) - 20
        cell.imgView.frame.size.height = (self.collectionView.frame.width / 2) - 20
        cell.imgView.image = images[indexPath.row]
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.collectionView.frame.width / 2) - 20
        return CGSize(width: width, height: width)
    }
    

}

