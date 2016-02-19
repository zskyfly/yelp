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

    weak var delegate: FiltersViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self


        self.categories = self.getYelpCategories()
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as! SwitchCell
        let index = indexPath.row
        cell.delegate = self
        cell.category = self.categories[index]
        cell.onSwitch.on = self.switchStates[index] ?? false
        return cell
    }
}

extension FiltersViewController: UITableViewDelegate {}

extension FiltersViewController: SwitchCellDelegate {

    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPathForCell(switchCell)!
        self.switchStates[indexPath.row] = value
    }
}

