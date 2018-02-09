//
//  ActivityListViewController.swift
//  Plotter
//
//  Created by Scott P. Chow on 1/28/18.
//  Copyright © 2018 scottpchow. All rights reserved.
//

import UIKit
import FRDStravaClient

class ActivityListViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var activities = [StravaActivity]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        StravaActivitiesService.shared.getActivities { (activities) in
            self.activities = activities
            self.tableView.reloadData()
        }
    }
    
    func tableViewSetup() {
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    }
}

extension ActivityListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell") as! ActivityTableViewCell
        cell.titleLabel.text = activities[indexPath.row].name
        cell.distanceLabel.text = String(format: "%.1f mi", (activities[indexPath.row].distance/1609.34))
        cell.dateLabel.text = activities[indexPath.row].startDate.description
        return cell
    }
}
