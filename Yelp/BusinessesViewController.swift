//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {

    var businesses: [Business]!
    

    var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        self.searchBar = UISearchBar()
        self.searchBar.sizeToFit()
        self.searchBar.placeholder = "Restaurants"
        self.searchBar.delegate = self
        navigationItem.titleView = searchBar

        // TODO: Why doesn't searchController work?
//        let searchController = UISearchController()
//        searchController.searchBar.sizeToFit()
//        searchController.hidesNavigationBarDuringPresentation = false
//        navigationItem.titleView = searchController.searchBar

        Business.searchWithTerm("", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })

/* Example of Yelp search with more search options specified
        Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        }
*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let navigationController = segue.destinationViewController as! UINavigationController
        let filtersViewController = navigationController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }
}

extension BusinessesViewController: UITableViewDataSource {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let businesses = self.businesses {
            return businesses.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        cell.business = self.businesses[indexPath.row]
        return cell
    }
}

extension BusinessesViewController: UITableViewDelegate {}

extension BusinessesViewController: FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [SearchFilter]) {
        let searchParams = SearchFilter.getSearchParams(filters)
        var searchTerm = ""
        if let searchText = self.searchBar.text {
            searchTerm = searchText
        }
        Business.searchWithTerm(searchTerm, sort: searchParams.sort, categories: searchParams.categories, deals: searchParams.deals ?? nil) { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        }
    }
}

extension BusinessesViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true;
    }

    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        return true;
    }

    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if let searchTerm = self.searchBar.text {
            Business.searchWithTerm(searchTerm) { (businesses: [Business]!, error: NSError!) -> Void in
                self.businesses = businesses
                self.tableView.reloadData()
            }
        }
        searchBar.resignFirstResponder()
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {

    }
}


