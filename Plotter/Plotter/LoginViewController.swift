//
//  LoginViewController.swift
//  Plotter
//
//  Created by Scott P. Chow on 1/28/18.
//  Copyright © 2018 scottpchow. All rights reserved.
//

import UIKit
import FRDStravaClient

class LoginViewController: UIViewController {

    @IBOutlet weak var stravaLoginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpButton()
        
    }
    
    func setUpButton() {
        stravaLoginButton.layer.cornerRadius = 10
    }
    
    @IBAction func stravaLoginTUI(_ sender: Any) {
        let callbackURL = URL(string: "plotter://com.scottpchow.Plotter/authorization")
//        let stateInfo = ""
        FRDStravaClient.sharedInstance().authorize(withCallbackURL: callbackURL, stateInfo: nil)
    }

}
