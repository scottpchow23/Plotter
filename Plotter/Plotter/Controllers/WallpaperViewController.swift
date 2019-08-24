//
//  WallpaperViewController.swift
//  Plotter
//
//  Created by Scott P. Chow on 2/10/18.
//  Copyright © 2018 scottpchow. All rights reserved.
//

import UIKit
import FRDStravaClient

class WallpaperViewController: UIViewController {

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pathView: UIView!
    var activity: StravaActivity?
    var path: CGPath?
    var initialHeight: CGFloat = 0

    var initialCenter: CGPoint = CGPoint(x: 0, y: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let path = path {
            let pathLayer = CAShapeLayer()
            pathLayer.lineWidth = 2
            pathLayer.strokeColor = UIColor(red: 251 / 255 , green: 76 / 255, blue: 3 / 255, alpha:1).cgColor
            pathLayer.fillColor = UIColor.clear.cgColor
            pathLayer.path = path
            pathView.layer.addSublayer(pathLayer)
        }
        initialCenter = pathView.center
        if let activity = activity {
            titleLabel.text = activity.name
            distanceLabel.text = String(format: "%.1f mi", (activity.distance/1609.34))
        }
        setUpLongPress()
        setupPathPanGesture()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleBackButton))
        self.view.addGestureRecognizer(tapGesture)
    }
    override func viewDidAppear(_ animated: Bool) {
        initialHeight = backButton.frame.minY
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    func setUpLongPress() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressGesture(_:)))
        self.view.addGestureRecognizer(gesture)
    }

    func setupPathPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePathPanGesture(_:)))
        pathView.addGestureRecognizer(panGesture)

    }

    @objc func handleLongPressGesture(_ gestureRecognizer : UILongPressGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        var image: UIImage? = nil
        if gestureRecognizer.state == .began {
            let view = self.view!
            UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
            var success = false
            if let currentContext = UIGraphicsGetCurrentContext() {
                success = true
                view.layer.render(in: currentContext)
                image = UIGraphicsGetImageFromCurrentImageContext()
            } else {
                print("Failed to screen cap")
            }
            UIGraphicsEndImageContext()

            if let image = image, success {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                print("Saved!")
            } else {
                print("Something went wrong")
            }
        }
    }

    @objc func handlePathPanGesture(_ gestureRecognizer : UIPanGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }

        let panningView = gestureRecognizer.view!
        let translation = gestureRecognizer.translation(in: panningView.superview)

        if gestureRecognizer.state == .began {
            initialCenter = panningView.center
        }

        if gestureRecognizer.state != .cancelled {
            let newCenter = CGPoint(x: initialCenter.x + translation.x, y: initialCenter.y + translation.y)
            panningView.center = newCenter
        }


    }
    
    @objc func toggleBackButton() {
        let sHeight = view.bounds.height
        let bounds = backButton.frame
        if bounds.minY < sHeight {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                print(self.backButton.frame)
                self.backButton.frame = CGRect(x: 0, y: sHeight, width: bounds.width, height: bounds.height)
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                print(self.backButton.frame)
                self.backButton.frame = CGRect(x: 0, y: self.initialHeight, width: bounds.width, height: bounds.height)
            }, completion: nil)
        }
    }
    
    @IBAction func backTUI(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
