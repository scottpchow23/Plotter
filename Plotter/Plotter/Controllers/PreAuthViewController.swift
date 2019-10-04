//
//  PreAuthViewController.swift
//  Plotter
//
//  Created by Scott P. Chow on 8/25/19.
//  Copyright © 2019 scottpchow. All rights reserved.
//

import UIKit

class PreAuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        StravaAuth.checkToken(with: { currentAthlete in
            print(currentAthlete?.firstName ?? "Invalid Athlete first name")
            self.transitionPastLogin()
        }) { (error) in
            print(error?.localizedDescription ?? "Error with no description")
            self.transitionToLogin()
        }
    }

    func transitionToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: "LoginVC")

        UIView.transition(from: self.view, to: navVC.view, duration: 0.3, options: [.transitionCrossDissolve], completion: { (_) in
            UIApplication.shared.keyWindow?.rootViewController = navVC
        })
    }

    func transitionPastLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: "NavController")

        UIView.transition(from: self.view, to: navVC.view, duration: 0.3, options: [.transitionCrossDissolve], completion: { (_) in
            UIApplication.shared.keyWindow?.rootViewController = navVC
        })
    }
}
