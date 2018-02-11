//
//  ActivityDetailViewController.swift
//  Plotter
//
//  Created by Scott P. Chow on 2/9/18.
//  Copyright © 2018 scottpchow. All rights reserved.
//

import UIKit
import FRDStravaClient
import Polyline
import MapKit

class ActivityDetailViewController: UIViewController {

    
    @IBOutlet weak var framePromptLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    var activity: StravaActivity?
    var path: CGPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        self.title = "Framing"
        if let startLocation = activity?.startLocation {
            self.mapView.setCenter(startLocation, animated: true)
            let visibleRect = MKCoordinateRegionMakeWithDistance(startLocation, CLLocationDistance((activity?.distance)!), CLLocationDistance((activity?.distance)!))
            let region = self.mapView.regionThatFits(visibleRect)
            self.mapView.setRegion(region, animated: true)
        }
        if let line = updatePath() {
            mapView.add(line)
        }
    }
    @IBAction func captureTUI(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let wallpaperVC = storyboard.instantiateViewController(withIdentifier: "WallpaperVC") as! WallpaperViewController
        _ = updatePath()
        wallpaperVC.path = self.path
        wallpaperVC.activity = self.activity
        self.present(wallpaperVC, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if framePromptLabel.frame.minY > navigationController?.navigationBar.frame.height ?? 100 {
            UIView.animate(withDuration: 0.3, delay: 1, options: [.curveEaseOut], animations: {
                self.mapView.frame = CGRect(x: 0, y: self.framePromptLabel.frame.minY, width: UIScreen.main.bounds.width, height: self.mapView.frame.height + self.framePromptLabel.frame.height)
                self.framePromptLabel.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0)
                
            }, completion: nil)
        }
    }
    
    func updatePath() -> MKPolyline? {
        if let activity = activity {
            let polyline = Polyline(encodedPolyline: activity.map.summaryPolyline)
            let mkpolyline = polyline.mkPolyline
            if let line = mkpolyline {
                let mapPoints = line.points()
                var points = [CGPoint]()
                for point in 0..<line.pointCount {
                    let location = MKCoordinateForMapPoint(mapPoints[point])
                    points.append(mapView.convert(location, toPointTo: view))
                }
                print(points)
                path = UIBezierPath(points: points).cgPath
                return line
            }
        }
        return nil
    }
}

extension ActivityDetailViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay.isKind(of: MKPolyline.self) {
            let polyLine = overlay
            let polyLineRenderer = MKPolylineRenderer(overlay: polyLine)
            polyLineRenderer.strokeColor = UIColor(red: 251 / 255 , green: 76 / 255, blue: 3 / 255, alpha:1)
            polyLineRenderer.lineWidth = 2.0
            
            return polyLineRenderer
        }
        return MKOverlayRenderer()
    }
}

extension UIBezierPath {
    convenience init(points:[CGPoint])
    {
        self.init()
        
        for (index,aPoint) in points.enumerated()
        {
            if index == 0 {
                self.move(to: aPoint)
            }
            else {
                self.addLine(to: aPoint)
            }
        }
    }
}
