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
import CircleProgressBar
import Alamofire
import AlamofireObjectMapper

var timer = Timer()
var isRunning = true
var arrayImages = [String]()
var arrayTimes = [String]()
var ind = 0


let southWest = CLLocationCoordinate2D(latitude: 47.407, longitude: 17.44)
let northEast = CLLocationCoordinate2D(latitude: 44.657, longitude: 12.1)
let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)

class ViewControllerCountry: UIViewController, GMSMapViewDelegate {
  
    @IBAction func cameras(_ sender: Any) {
        startStopAction()
        self.mapview.clear()
        let URL = "https://opendata.si/promet/cameras/"
        Alamofire.request(URL).responseObject { (response: DataResponse<CameraWrapper>) in
            let weatherResponse = response.result.value
            for x in (weatherResponse?.Contents?.first?.Data?.Items)!
            {
                //print(x.camera?.first?.image)
                let position = CLLocationCoordinate2D(latitude: x.y_wgs,longitude: x.x_wgs)
                let marker = GMSMarker(position: position)
                marker.userData = x.camera?.first?.image
                marker.title = x.title
                marker.map = self.mapview
            }
        }
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: {
            timer.invalidate()
        })
    }
    @IBOutlet weak var cpc: CircularProgressClock!
    @IBOutlet weak var bottomview: UIView!
    @IBOutlet weak var mapview: GMSMapView!
    @IBOutlet weak var startstop: UIButton!
    /*@IBAction func bottomsheets(_ sender: Any) {
        bottomview.frame = CGRect(x:0, y: 0, width:0, height:bottomview.frame.height + 350)

    }*/
    
    @IBAction func startstop(_ sender: Any) {
        startStopAction()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledTimerWithTimeInterval()
        let (imageurls,imagetimes) = getImageUrls()
        arrayImages = imageurls
        arrayTimes = imagetimes
        let camera = GMSCameraPosition.camera(withLatitude: 46.018851, longitude: 14.675335, zoom: 7.1)
        self.mapview.camera = camera
        self.mapview.delegate = self
   
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImageUrls() -> ([String],[String])
    {
        var imageUrls = [String]()
        var imageTimes = [String]()
        let imageCount = 11.0
        //get date in UTC
        let gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        let minutes = components.minute!
        
        if (minutes >= 0 && minutes < 11)
        {
            components.hour = (components.hour!-1)
            components.minute = 50
        }
        if (minutes >= 11 && minutes < 21)
        {
            components.minute = 0
        }
        if (minutes >= 21 && minutes < 31)
        {
            components.minute = 10
        }
        if (minutes >= 31 && minutes < 41)
        {
            components.minute = 20
        }
        if (minutes >= 41 && minutes < 51)
        {
            components.minute = 30
        }
        if (minutes >= 51 && minutes < 60)
        {
            components.minute = 40
        }
 
        let baseUrl = "http://meteo.arso.gov.si/uploads/probase/www/nowcast/inca/inca_si0zm_";
        let formatter1 = DateFormatter()
        let formatter2 = DateFormatter()
    
        formatter1.dateFormat = "yyyyMMdd-HHmm"
        formatter2.dateFormat = "HH:mm"
        
        formatter1.timeZone = TimeZone(abbreviation: "UTC")
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        formatter2.timeZone = TimeZone(identifier: timeZone)
        var date = gregorian.date(from: components)
        date?.addTimeInterval(-imageCount * 10.0 * 60.0)
        for _ in 0...Int(imageCount)
        {
            let formattedDate = formatter1.string(from: date!)
            let theUrl = baseUrl + formattedDate + "+0000.png";
            imageUrls.append(theUrl)
            imageTimes.append(formatter2.string(from: date!))
           
            date!.addTimeInterval(10.0 * 60)
        }
        return (imageUrls, imageTimes)
    }

    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        if(ind < 11)
        {
            let url = URL(string: arrayImages[ind])
            self.cpc.progress = CGFloat(ind*10)
            self.cpc.title = arrayTimes[ind]
            KingfisherManager.shared.retrieveImage(with: url!, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                let overlay = GMSGroundOverlay(bounds: overlayBounds, icon: image)
                overlay.bearing = 0
                self.mapview.clear()
                overlay.map = self.mapview
            })
            ind = ind+1
        }
        else
        {
            ind = 0
        }
    }
    func startStopAction()
    {
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
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let alert = UIAlertController(title: marker.title, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
    
        let imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: alert.view.bounds.size.width - 10 * 4.0, height: alert.view.bounds.size.width-30))
        let urlWithCacheBurner = marker.userData as! String + "?t=" + String(Int(Date().timeIntervalSince1970 * 1000))
        
        let url = URL(string: urlWithCacheBurner as! String)
        imageView.kf.setImage(with: url)
        alert.view.addSubview(imageView)
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.70)
        
        alert.view.addConstraint(height)
        self.present(alert, animated: true, completion: nil)
        
        return true
    }
}
