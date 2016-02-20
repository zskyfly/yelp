//
//  SearchFilterSection.swift
//  Yelp
//
//  Created by Zachary Matthews on 2/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

enum SectionType: Int {
    case Deals = 0, Distance, SortBy, Category
}

class SearchFilter {

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

    class func getSearchParams(searchFilters: [SearchFilter]) -> SearchParams {

        let searchParams = SearchParams()
        for filter in searchFilters {
            switch filter.sectionType! {

            case SectionType.Category:
                searchParams.categories = getSearchCategories(filter)

            case SectionType.Deals:
                searchParams.deals = filter.states[0]

            case SectionType.Distance:
                if let selected = filter.selectedIndex {
                    searchParams.distance = filter.values[selected].code as? Int
                }
                
            case SectionType.SortBy:
                if let selected = filter.selectedIndex {
                    searchParams.sort = YelpSortMode(rawValue: selected)
                }
            }
        }
        return searchParams
    }

    class func getSearchCategories(searchFilter: SearchFilter) -> [String]! {
        var categories = [String]()
        for (index, selected) in searchFilter.states {
            if selected {
                categories.append(searchFilter.values[index].code as! String)
            }
        }
        return categories
    }
}

class SearchParams {

    var sort: YelpSortMode?
    var deals: Bool?
    var categories: [String]!
    var distance: Int?

    init (sort: YelpSortMode? = nil, deals: Bool? = nil, categories: [String]! = [String](), distance: Int? = nil) {
        self.sort = sort
        self.deals = deals
        self.categories = categories
        self.distance = distance
    }
}
