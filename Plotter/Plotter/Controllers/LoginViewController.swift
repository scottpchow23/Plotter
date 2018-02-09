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
    
    override func viewDidAppear(_ animated: Bool) {
        checkStatus()
    }
    
    func checkStatus() {
        stravaLoginButton.isEnabled = false
        print("Starting check")
        StravaAuth.checkToken(with: { (athlete) in
            print("Got athelete?")
            if let athlete = athlete {
                self.skipLogin(athlete: athlete)
            } else {
                self.stravaLoginButton.isEnabled = true
            }
        }) { (error) in
            print("Got error: \(String(describing: error?.localizedDescription))")
            self.stravaLoginButton.isEnabled = true
        }
    }
    
    func skipLogin(athlete: StravaAthlete) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: "NavController")
                
        UIView.transition(from: self.view, to: navVC.view, duration: 0.3, options: [.transitionCrossDissolve], completion: { (_) in
            UIApplication.shared.keyWindow?.rootViewController = navVC
        })
    }
    
    func setUpButton() {
        stravaLoginButton.layer.cornerRadius = 10
    }
    
    @IBAction func stravaLoginTUI(_ sender: Any) {
        let callbackURL = URL(string: "plotter://com.scottpchow.Plotter/authorization")
        FRDStravaClient.sharedInstance().authorize(withCallbackURL: callbackURL, stateInfo: nil)
    }

}
