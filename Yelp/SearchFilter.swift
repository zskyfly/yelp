//
//  SearchFilterSection.swift
//  Yelp
//
//  Created by Zachary Matthews on 2/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import Foundation
import UIKit

protocol SearchFilter {

    var sectionName: String! {get set}
    var sectionType: FilterSection! {get set}
    var rowCount: Int! {get set}
    var cellIdentifier: String! {get set}
    var values: [AnyObject]! {get set}

    func getTitleForHeaderInSection() -> String

    func getNumberOfRowsInSection() -> Int
}

public func getAllSearchFilters() -> [AnyObject] {
    let distanceValues = [
        ["name" : ".3 miles", "code": "1"],
        ["name" : "1 mile", "code": "2"],
        ["name" : "5 miles", "code": "3"],
        ["name" : "20 miles", "code": "4"],
    ]

    let sortByValues = [
        ["name": "Best Match", "code": "0"],
        ["name": "Distance", "code": "1"],
        ["name": "Highest Rated", "code": "2"]
    ]
    let searchCategories = YelpCategory.getAllCategories()
    let allFilters = [
        SearchFilterSwitch(sectionType: FilterSection.Deals, sectionName: "", rowCount: 1, values: ["OfferDeals"]),
        SearchFilterSegmented(sectionType: FilterSection.Distance, sectionName: "Distance", values: YelpCategory.getCategoriesFromDictionary(distanceValues)),
        SearchFilterSegmented(sectionType: FilterSection.SortBy, sectionName: "Sort By", values: YelpCategory.getCategoriesFromDictionary(sortByValues)),
        SearchFilterSwitch(sectionType: FilterSection.Category, sectionName: "Category", rowCount: searchCategories.count , values: searchCategories),
    ]

//    SectionName.Deals: SearchFilter(sectionName: "", rowCount: 1, cellIdentifier: "SwitchCell", values: ["Offers Deals"]),
//    SectionName.Distance: SearchFilter(sectionName: "Distance", rowCount: 5, cellIdentifier: "SegmentedCell", values: [".3 miles", "1 mile", "2 miles", "5 miles", "20 miles"]),
//    SectionName.SortBy: SearchFilter(sectionName: "Sort By", rowCount: 3, cellIdentifier: "SegmentedCell", values: ["Best Match", "Distance", "Highest Rated"]),
//    SectionName.Category: SearchFilter(sectionName: "Category", rowCount: self.categories.count, cellIdentifier: "SwitchCell", values: self.categories),
    return allFilters as [AnyObject]
}

public enum FilterSection: Int {
    case Deals = 0, Distance, SortBy, Category
}

class SearchFilterSwitch: SearchFilter {

    var sectionType: FilterSection!
    var sectionName: String!
    var rowCount: Int!
    var cellIdentifier: String!
    var values: [AnyObject]!
    var states: [Int: AnyObject]!

    init(sectionType: FilterSection, sectionName: String, rowCount: Int, cellIdentifier: String = "SwitchCell", values: [AnyObject], startState: Bool = false) {
        self.sectionType = sectionType
        self.sectionName = sectionName
        self.rowCount = rowCount
        self.cellIdentifier = cellIdentifier
        self.values = values
        for (index, _) in self.values.enumerate() {
            self.states[index] = startState
        }
    }

    func getTitleForHeaderInSection() -> String {
        return sectionName
    }

    func getNumberOfRowsInSection() -> Int {
        return values.count
    }

    func getValueForIndex(index: Int) -> YelpCategory {
        return self.values[index] as! YelpCategory
    }
    
    
}

class SearchFilterSegmented: SearchFilter {

    var sectionType: FilterSection!
    var sectionName: String!
    var rowCount: Int!
    var cellIdentifier: String!
    var values: [AnyObject]!
    var selectedIndex: Int?

    init(sectionType: FilterSection, sectionName: String, cellIdentifier: String = "SegmentedCell", values: [AnyObject]) {
        self.sectionType = sectionType
        self.sectionName = sectionName
        self.rowCount = 1
        self.cellIdentifier = cellIdentifier
        self.values = values
    }

    func getTitleForHeaderInSection() -> String {
        return sectionName
    }

    func getNumberOfRowsInSection() -> Int {
        return values.count
    }

    func getSegmentNames(index: Int = 0) -> [String] {
        return self.values[index] as! [String]
    }
    
    
}
