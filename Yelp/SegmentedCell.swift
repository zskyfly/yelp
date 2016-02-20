//
//  SegmentedCell.swift
//  Yelp
//
//  Created by Zachary Matthews on 2/19/16.
//  Copyright © 2016 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol SegmentedCellDelegate {
    optional func segmentedCell(segmentedCell: SegmentedCell, didChangeValue value: Int)
}

class SegmentedCell: UITableViewCell {

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    weak var delegate: SegmentedCellDelegate?
    var selectedIndex: Int?
    var segmentNames: [SearchFilterValue]! {
        didSet {
            self.buildSegmentedControl()
            if let selectedIndex = self.selectedIndex {
                segmentedControl.selectedSegmentIndex = selectedIndex
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        segmentedControl.addTarget(self, action: "selectedIndexChanged", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func buildSegmentedControl() {
        segmentedControl.removeAllSegments()
        for (index, value) in self.segmentNames.enumerate() {
            segmentedControl.insertSegmentWithTitle(value.name, atIndex: index, animated: false)
        }
    }

    func selectedIndexChanged() {
        delegate?.segmentedCell?(self, didChangeValue: segmentedControl.selectedSegmentIndex)
    }

}
