//
//  StravaAuth.swift
//  Plotter
//
//  Created by Scott P. Chow on 1/28/18.
//  Copyright © 2018 scottpchow. All rights reserved.
//

import Foundation
import FRDStravaClient

class StravaAuth {
    static let shared = StravaAuth()
    static let ACCESS_TOKEN = "accessToken"
    static var currentAthlete: StravaAthlete?
    
    static func login(with url:URL, success: @escaping (StravaAthlete?) -> (), failure: @escaping (Error?)->()) {
        FRDStravaClient.sharedInstance().parseStravaAuthCallback(url, withSuccess: { (stateInfo, code) in
            FRDStravaClient.sharedInstance().exchangeToken(forCode: code, success: { (response) in
                if let response = response {
                    UserDefaults.standard.set(response.accessToken, forKey: ACCESS_TOKEN)
                    currentAthlete = response.athlete
                    success(response.athlete)
                }
            }, failure: { (error) in
                print(error?.localizedDescription ?? "Some error occured in exchanging the token.")
                failure(error)
            })
        }) { (stateInfo, code) in
            print("FRDSTRAVACLIENT: Failure in parseStravaAuthCallback")
            failure(nil)
        }
    }
    
    static func checkToken(with success: @escaping (StravaAthlete?) -> (), failure: @escaping (Error?)->()) {
        if let accessToken = readFromDefaults() {
            FRDStravaClient.sharedInstance().accessToken = accessToken
        }
        
        if FRDStravaClient.sharedInstance().accessToken != nil {
            FRDStravaClient.sharedInstance().fetchCurrentAthlete(success: { (athlete) in
                success(athlete)
            }) { (error) in
                logout()
                failure(error)
            }
        } else {
            failure(nil)
        }
        
        
    }
    
    static func readFromDefaults() -> String? {
        let accessToken = UserDefaults.standard.string(forKey: ACCESS_TOKEN)
        return accessToken
    }
    
    static func logout() {
        FRDStravaClient.sharedInstance().accessToken = ""
        UserDefaults.standard.set("", forKey: ACCESS_TOKEN)
    }
}
