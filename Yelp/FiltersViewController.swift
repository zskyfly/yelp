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
    var searchFilters: [AnyObject]!

    weak var delegate: FiltersViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self


//        self.categories = self.getYelpCategories()
        self.searchFilters = getAllSearchFilters()


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
        return self.searchFilters[section]
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let whichSection = FilterSection(rawValue: section) else {
            return 0
        }
        return self.searchFilters[whichSection]!.rowCount
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell

        let whichSection = FilterSection(rawValue: indexPath.section)!

        let index = indexPath.row

        switch whichSection {

        case FilterSection.Category, FilterSection.Deals:
            let switchCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            let searchFilter = self.searchFilters[whichSection] as! SearchFilterSwitch
            switchCell.searchFilter = searchFilter
            switchCell.valueIndex = index
            switchCell.delegate = self
            cell = switchCell

        case FilterSection.Distance, FilterSection.SortBy:
            let segmentedCell = tableView.dequeueReusableCellWithIdentifier("SegmentedCell", forIndexPath: indexPath) as! SegmentedCell
            let searchFilter = self.searchFilters[whichSection] as! SearchFilterSegmented
            segmentedCell.searchFilter = searchFilter
            segmentedCell.delegate = self
            cell = segmentedCell

        default:
            cell = UITableViewCell()
        }



//
//        if whichSection == SectionName.Category {
//            cell.category = self.categories[index]
//        } else {
//            cell.switchLabel.text = searchFilter.values[index] as! String
//        }
//        cell.onSwitch.on = self.switchStates[index] ?? false
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

extension FiltersViewController: SegmentedCellDelegate {

    func segmentedCell(segmentedCell: SegmentedCell, didChangeValue value: Int) {
        let indexPath = tableView.indexPathForCell(segmentedCell)!
    }
}

