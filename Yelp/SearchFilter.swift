//
//  SearchFilterSection.swift
//  Yelp
//
//  Created by Zachary Matthews on 2/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

class SearchFilter {

    var sectionName: String!
    var rowCount: Int!
    var cellIdentifier: String!
    var values: [AnyObject]!

    init(sectionName: String, rowCount: Int, cellIdentifier: String, values: [AnyObject]) {
        self.sectionName = sectionName
        self.rowCount = rowCount
        self.cellIdentifier = cellIdentifier
        self.values = values
    }
}
