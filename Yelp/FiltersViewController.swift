//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Zachary Matthews on 2/18/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit


protocol FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [SearchFilter])
}

class FiltersViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var searchFilters: [SearchFilter]!
    var delegate: FiltersViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        self.searchFilters = SearchFilter.getAllSearchFilters()
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
        delegate?.filtersViewController(self, didUpdateFilters: self.searchFilters)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func getYelpCategories() -> [SearchFilterValue] {
        return SearchFilterValue.getAllCategories()
    }

}

extension FiltersViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let searchFilter = self.searchFilters[section]
        return searchFilter.sectionName
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let searchFilter = self.searchFilters[section]
        switch searchFilter.cellIdentifier {

        case "SwitchCell":
            return searchFilter.values.count

        case "SegmentedCell":
            return 1

        default:
            return 0
        }

    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        let section = indexPath.section
        let index = indexPath.row

        let searchFilter = self.searchFilters[section]
        let searchFilterValues = searchFilter.values
        let selectedIndex = searchFilter.selectedIndex
        let searchFilterValue = searchFilterValues[index]
        let searchFilterState = searchFilter.states[index]

        switch searchFilter.cellIdentifier {

        case "SwitchCell":
            let switchCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
            switchCell.delegate = self
            switchCell.filterState = searchFilterState
            switchCell.filterValue = searchFilterValue
            cell = switchCell
            break

        case "SegmentedCell":
            let segmentedCell = tableView.dequeueReusableCellWithIdentifier("SegmentedCell", forIndexPath: indexPath) as! SegmentedCell
            segmentedCell.delegate = self
            segmentedCell.selectedIndex = selectedIndex
            segmentedCell.segmentNames = searchFilterValues
            cell = segmentedCell
            break

        default:
            cell = UITableViewCell()
        }

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
        let section = indexPath.section
        let row = indexPath.row

        self.searchFilters[section].states[row] = value
    }
}

extension FiltersViewController: SegmentedCellDelegate {

    func segmentedCell(segmentedCell: SegmentedCell, didChangeValue value: Int) {
        let indexPath = tableView.indexPathForCell(segmentedCell)!
        let section = indexPath.section

        self.searchFilters[section].selectedIndex = value
    }
}

