//
//  CategoryTree.swift
//  Scraping
//
//  Created by Gbenga Ayobami on 2018-03-13.
//  Copyright © 2018 Gbenga Ayobami. All rights reserved.
//

import Foundation
class Category{
    var name: String!
    var links:[String] = []
    init(name: String) {
        self.name = name
    }
}
