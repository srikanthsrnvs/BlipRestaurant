//
//  CategoryRow.swift
//  Blip
//
//  Created by Gbenga Ayobami on 2018-03-08.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit

class CategoryRow: UITableViewCell{

    @IBOutlet weak var collectionView: UICollectionView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "categoryCell")
        self.collectionView.register(UINib(nibName:"CustomCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "categoryCell")
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}


extension CategoryRow: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        /*
         Leave the commented code for future reference
         */
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CustomCollectionViewCell
        //        let jobViewFromNib = Bundle.main.loadNibNamed("PopUpJobView", owner: self, options: nil)?.first as! PopUpJobViewVC
//        let cell = Bundle.main.loadNibNamed("CustomCollectionViewCell", owner: self, options: nil)?.first as! CustomCollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "categoryCell", for: indexPath) as! CustomCollectionViewCell
//        cell.frame.size = CGSize(width: CGFloat(120), height: CGFloat(120))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
