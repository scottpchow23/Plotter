//
//  StravaActivitiesService.swift
//  Plotter
//
//  Created by Scott P. Chow on 1/29/18.
//  Copyright © 2018 scottpchow. All rights reserved.
//

import Foundation
import FRDStravaClient

class StravaActivitiesService {
    static let shared = StravaActivitiesService()
    
    func getActivities(with completion: @escaping ([StravaActivity])->()) {
        FRDStravaClient.sharedInstance().fetchActivitiesForCurrentAthlete(success: { (rawActivities) in
            if let activities = rawActivities as? [StravaActivity] {
                completion(activities)
            } else {
                print("Bad cast")
            }
        }, failure: { (error) in
            if let error = error {
                print(error)
            }
            completion([StravaActivity]())
        })
        completion([StravaActivity]())
    }
}
