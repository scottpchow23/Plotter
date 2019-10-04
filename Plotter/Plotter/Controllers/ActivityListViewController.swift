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
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
    @IBAction func logoutTUI(_ sender: Any) {
        StravaAuth.logout()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")
        
        UIView.transition(from: (self.navigationController?.view)!, to: loginVC.view, duration: 0.3, options: [.transitionCrossDissolve], completion: { (_) in
            UIApplication.shared.keyWindow?.rootViewController = loginVC
        })
    }
}

extension ActivityListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell") as! ActivityTableViewCell
        let activity = activities[indexPath.row]
        cell.activity = activity
        cell.distanceLabel.text = String(format: "%.1f mi", (activity.distance/1609.34))
        cell.dateLabel.text = activity.startDate.description
        cell.titleLabel.text = activity.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedCell = tableView.cellForRow(at: indexPath) as! ActivityTableViewCell
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destinationVC = storyboard.instantiateViewController(withIdentifier: "ActivityDetailVC") as! ActivityDetailViewController
        destinationVC.activity = selectedCell.activity
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
}
