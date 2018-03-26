//
//  ItemTableViewViewController.swift
//  Blip
//
//  Created by Srikanth Srinivas on 2018-03-22.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Material
import Graph

class ItemTableView: TableView {
    /**
     Retrieves the data source items for the tableView.
     - Returns: An Array of DataSourceItem objects.
     */
    var dataSourceItems = [DataSourceItem]() {
        didSet {
            reloadData()
        }
    }
    
    /// Prepares the tableView.
    open override func prepare() {
        super.prepare()
        self.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "ItemTableViewCell")
        dataSource = self
        delegate = self
    }
}

extension ItemTableView: TableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSourceItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /// Prepares the cells within the tableView.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell", for: indexPath)
        
//        guard let category = dataSourceItems[indexPath.row].data as? Entity else {
//            return cell
//        }
//        cell.itemLabel.text = category["ItemName"] as? String
//        cell.itemImage.image = UIImage.image(with: UIColor.black, size: cell.itemImage.frame.size)
//        cell.dividerColor = Color.grey.lighten2
        
        return cell
    }
}

extension ItemTableView: TableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
