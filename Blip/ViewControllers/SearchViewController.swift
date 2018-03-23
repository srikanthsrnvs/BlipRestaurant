//
//  SearchViewController.swift
//  Blip
//
//  Created by Srikanth Srinivas on 2018-03-22.
//  Copyright © 2018 Blip Groceries. All rights reserved.
//

import UIKit
import Material
import Graph
import SwiftIcons

class SearchViewController: UIViewController {

    
    // Model.
    fileprivate var searchBar: SearchBar!
    internal var graph: Graph!
    internal var search: Search<Entity>!
    
    // View.
    internal var tableView: ItemTableView!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.grey.lighten5
        
        // Prepare view.
        prepareSearchBar()
        prepareTableView()
        
        // Prepare model.
        prepareGraph()
        prepareSearch()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView?.reloadData()
    }
}

/// Model.
extension  SearchViewController{
    internal func prepareGraph() {
        graph = Graph()
        
        // Uncomment to clear the Graph data.
        //        graph.clear()
    }
    
    internal func prepareSearch() {
        search = Search<Entity>(graph: graph).for(types: "User").where(properties: "name")
        
        search.async { [weak self] (data) in
            if 0 == data.count {
                SampleData.createData()
            }
            self?.reloadData()
        }
    }
    
    internal func prepareTableView() {
        tableView = ItemTableView()
        view.layout(tableView).edges(top: searchBar.frame.size.height + UIApplication.shared.statusBarFrame.height, left: 0, bottom: 0, right: 0)
    }
    
    internal func reloadData() {
        var dataSourceItems = [DataSourceItem]()
        
        let users = search.sync().sorted(by: { (a, b) -> Bool in
            guard let n = a["ItemName"] as? String, let m = b["ItemName"] as? String else {
                return false
            }
            
            return n < m
        })
        
        users.forEach {
            dataSourceItems.append(DataSourceItem(data: $0))
        }
        
        tableView.dataSourceItems = dataSourceItems
    }
}

extension SearchViewController: SearchBarDelegate {
     func prepareSearchBar() {
        let greenView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        greenView.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        view.layout(greenView).edges()
        // Access the searchBar.
        searchBar = SearchBar()
        searchBar.delegate = self
        searchBar.backgroundColor = #colorLiteral(red: 0.4658077359, green: 0.7660514712, blue: 0.2661468089, alpha: 1)
        searchBar.textColor = UIColor.white
        searchBar.placeholderColor = UIColor.white
        let searchIcon = IconButton()
        searchIcon.setIcon(icon: .googleMaterialDesign(.search), color: UIColor.white, forState: .normal)
        
        searchBar.leftViews.append(searchIcon)
        view.layout(searchBar).top(UIApplication.shared.statusBarFrame.height).horizontally()
    }
    
    func searchBar(searchBar: SearchBar, didClear textField: UITextField, with text: String?) {
        reloadData()
    }
    
    func searchBar(searchBar: SearchBar, didChange textField: UITextField, with text: String?) {
        guard let pattern = text?.trimmed, 0 < pattern.utf16.count else {
            reloadData()
            return
        }
        
        search.async { [weak self, pattern = pattern] (users) in
            guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else {
                return
            }
            
            var dataSourceItems = [DataSourceItem]()
            
            for user in users {
                if let name = user["ItemName"] as? String {
                    let matches = regex.matches(in: name, range: NSRange(location: 0, length: name.utf16.count))
                    if 0 < matches.count {
                        dataSourceItems.append(DataSourceItem(data: user))
                    }
                }
            }
            
            self?.tableView.dataSourceItems = dataSourceItems
        }
    }
}


