//
//  AppDelegate.swift
//  Plotter
//
//  Created by Scott P. Chow on 1/28/18.
//  Copyright © 2018 scottpchow. All rights reserved.
//

import UIKit
import FRDStravaClient

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        let config = StravaConfig(clientId: 22970, clientSecret: "4ddee4f49fa62bfd7d88e2b129ab283114b1c72c", redirectUri: "plotter://com.scottpchow.Plotter/authorization")
        FRDStravaClient.sharedInstance().initialize(withClientId: 22970, clientSecret: "4ddee4f49fa62bfd7d88e2b129ab283114b1c72c")
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("URL scheme: \(String(describing: url.scheme))")
        print("URL: \(url.absoluteString)")
        if url.absoluteString.hasPrefix("plotter://com.scottpchow.Plotter/authorization") {
            StravaAuth.login(with: url, success: { (athlete) in
                if let athlete = athlete {
                    self.transitionPastLogin(athlete: athlete)
                }
            }, failure: { (error) in
                
            })
        }
        
        
        return true
    }
    
    
    
    func persistAccessToken(accessToken: String) {
        UserDefaults.standard.set(accessToken, forKey: "accessToken")
    }
    
    func transitionPastLogin(athlete: StravaAthlete) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = storyboard.instantiateViewController(withIdentifier: "NavController")
                
        UIView.transition(from: (self.window?.rootViewController?.view!)!, to: navVC.view, duration: 0.3, options: [.transitionCrossDissolve], completion: { (_) in
            self.window?.rootViewController = navVC
        })
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

