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

    internal enum SectionType: Int {
        case Deals = 0, Distance, SortBy, Category
    }

    var sectionName: String!
    var cellIdentifier: String!
    var values: [SearchFilterValue]!
    var states: [Int:Bool]!
    var selectedIndex: Int?
    var sectionType: SectionType!

    init(sectionName: String, sectionType: SectionType, cellIdentifier: String, values: [SearchFilterValue], defaultState: Bool = false, selectedIndex: Int? = nil) {
        self.sectionName = sectionName
        self.sectionType = sectionType
        self.cellIdentifier = cellIdentifier
        self.values = values
        self.states = [Int:Bool]()
        for (row, _) in values.enumerate() {
            self.states[row] = defaultState
        }
        self.selectedIndex = selectedIndex
    }

    class func getAllSearchFilters() -> [SearchFilter] {
        let allFilters = [
            SearchFilter(sectionName: "", sectionType: SectionType.Deals, cellIdentifier: "SwitchCell", values: SearchFilterValue.getAllDeals()),
            SearchFilter(sectionName: "Distances", sectionType: SectionType.Distance, cellIdentifier: "SegmentedCell", values: SearchFilterValue.getAllDistances()),
            SearchFilter(sectionName: "Sort By", sectionType: SectionType.SortBy, cellIdentifier: "SegmentedCell", values: SearchFilterValue.getAllSortBys()),
            SearchFilter(sectionName: "Categories", sectionType: SectionType.Category, cellIdentifier: "SwitchCell", values: SearchFilterValue.getAllCategories())
        ]
        return allFilters

    }
}
