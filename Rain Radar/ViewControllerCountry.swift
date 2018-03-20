//
//  ViewControllerCountry.swift
//  Rain Radar
//
//  Created by Simon Hočevar on 10/03/2018.
//  Copyright © 2018 Simon Hočevar. All rights reserved.
//

import UIKit
import GoogleMaps
import Kingfisher
var timer = Timer()
var isRunning = true
var array = [String]()
var ind = 0
let southWest = CLLocationCoordinate2D(latitude: 47.407, longitude: 17.44)
let northEast = CLLocationCoordinate2D(latitude: 44.657, longitude: 12.1)
let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)

class ViewControllerCountry: UIViewController {
    @IBOutlet weak var bottomview: UIView!
    
    @IBAction func bottomsheets(_ sender: Any) {
        bottomview.frame = CGRect(x:0, y: 0, width:0, height:bottomview.frame.height + 350)

    }
    @IBOutlet weak var startstop: UIButton!
    @IBAction func startstop(_ sender: Any) {
        if(isRunning)
        {
            timer.invalidate()
            startstop.setTitle("Start", for: .normal)
        }
        else
        {
            scheduledTimerWithTimeInterval()
            startstop.setTitle("Stop", for: .normal)
        }
        isRunning = !isRunning
        
    }
    @IBOutlet weak var mapview: GMSMapView!
    override func viewDidLoad() {
        scheduledTimerWithTimeInterval()
        super.viewDidLoad()
        array = getImageUrls()
        let url = URL(string: array[0])
        let southWest = CLLocationCoordinate2D(latitude: 47.407, longitude: 17.44)
        let northEast = CLLocationCoordinate2D(latitude: 44.657, longitude: 12.1)
        let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)
        
        KingfisherManager.shared.retrieveImage(with: url!, options: nil, progressBlock: nil)
        {
            (image, error, cacheType, imageURL) -> () in image
            let overlay = GMSGroundOverlay(bounds: overlayBounds, icon: image)
            overlay.bearing = 0
            overlay.map = self.mapview
        }
        let camera = GMSCameraPosition.camera(withLatitude: 46.018851, longitude: 14.675335, zoom: 7.1)
        self.mapview.camera = camera

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImageUrls() -> Array<String>
    {
        var imageUrls = [String]()
        var imageTimes = [String]()
        let imageCount = 11.0
        //get date in UTC
        let gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        let minutes = components.minute!
        
        if (minutes >= 0 && minutes <= 11)
        {
            components.hour = (components.hour!-1)
            components.minute = 50
        }
        if (minutes >= 11 && minutes <= 21)
        {
            components.minute = 0
        }
        if (minutes >= 21 && minutes <= 31)
        {
            components.minute = 10
        }
        if (minutes >= 31 && minutes <= 41)
        {
            components.minute = 20
        }
        if (minutes >= 41 && minutes <= 51)
        {
            components.minute = 30
        }
        if (minutes >= 51 && minutes <= 60)
        {
            components.minute = 40
        }
        components.minute = components.minute! - 60
        
        let baseUrl = "http://meteo.arso.gov.si/uploads/probase/www/nowcast/inca/inca_si0zm_";
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date
        formatter.dateFormat = "yyyyMMdd-HHmm"
        var date = gregorian.date(from: components)
        date?.addTimeInterval(-imageCount * 10.0 * 60.0)
        for _ in 0...Int(imageCount)
        {
            let formattedDate = formatter.string(from: date!)
            let theUrl = baseUrl + formattedDate + "+0000.png";
            imageUrls.append(theUrl)
            imageTimes.append(formattedDate)
           
            date!.addTimeInterval(10.0 * 60)
        }
        return imageUrls
    }

    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        print("counting..")
        if(ind < 11)
        {
            let url = URL(string: array[ind])
            
            
            KingfisherManager.shared.retrieveImage(with: url!, options: nil, progressBlock: nil)
            {
                (image, error, cacheType, imageURL) -> () in image
                let overlay = GMSGroundOverlay(bounds: overlayBounds, icon: image)
                overlay.bearing = 0
                self.mapview.clear()
                overlay.map = self.mapview
                
            }
            ind = ind+1
        }
        else
        {
            ind = 0
        }
    }

}
