//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Zachary Matthews on 2/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])
}

class FiltersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var categories: [YelpCategory]!
    var switchStates = [Int: Bool]()
    var searchFilters: [SectionName: SearchFilter]!

    enum SectionName: Int {
        case Deals = 0, Distance, SortBy, Category
    }

    weak var delegate: FiltersViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self


        self.categories = self.getYelpCategories()
        self.searchFilters = [
            SectionName.Deals: SearchFilter(sectionName: "", rowCount: 1, cellIdentifier: "SwitchCell", values: ["Offers Deals"]),
            SectionName.Distance: SearchFilter(sectionName: "Distance", rowCount: 5, cellIdentifier: "SegmentedCell", values: [".3 miles", "1 mile", "2 miles", "5 miles", "20 miles"]),
            SectionName.SortBy: SearchFilter(sectionName: "Sort By", rowCount: 3, cellIdentifier: "SegmentedCell", values: ["Best Match", "Distance", "Highest Rated"]),
            SectionName.Category: SearchFilter(sectionName: "Category", rowCount: self.categories.count, cellIdentifier: "SwitchCell", values: self.categories),
        ]

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearchButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        var filters = [String : AnyObject]()
        var selectedCategories = [String]()
        for (row, isSelected) in self.switchStates {
            if isSelected {
                selectedCategories.append(self.categories[row].code)
            }
        }
        filters["categories"] = selectedCategories
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func getYelpCategories() -> [YelpCategory] {
        return YelpCategory.getAllCategories()
    }

}

extension FiltersViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let whichSection = SectionName(rawValue: section)!
        return self.searchFilters[whichSection]?.sectionName
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let whichSection = SectionName(rawValue: section) else {
            return 0
        }
        return self.searchFilters[whichSection]!.rowCount
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let whichSection = SectionName(rawValue: indexPath.section)!
        let searchFilter = self.searchFilters[whichSection]!
        let index = indexPath.row
        let cellType = searchFilter.cellIdentifier
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
//        if cellType! == "SwitchCell" {
//
//        } else {
//            let cell = tableView.dequeueReusableCellWithIdentifier("SegmentedCell", forIndexPath: indexPath) as! SegmentedCell
//        }

        cell.delegate = self

        if whichSection == SectionName.Category {
            cell.category = self.categories[index]
        } else {
            cell.switchLabel.text = searchFilter.values[index] as! String
        }
        cell.onSwitch.on = self.switchStates[index] ?? false
        return cell
    }
}

extension FiltersViewController: UITableViewDelegate {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.searchFilters.count
    }
}

extension FiltersViewController: SwitchCellDelegate {

    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        self.switchStates[indexPath.row] = value
    }
}

