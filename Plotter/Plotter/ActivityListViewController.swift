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

    @IBOutlet weak var successLabel: UILabel!
    
    
    var athlete:StravaAthlete?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let athlete = athlete {
            successLabel.text = "Welcome to Plotter, \(athlete.firstName!)."
        }
    }


}
