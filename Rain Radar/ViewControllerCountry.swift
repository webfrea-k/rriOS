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
var startstop: UIButton?
var displaycamras: UIButton?
var recenter: UIButton?
var rainlayer: UIButton?
var cloudslayer: UIButton?
var haillayer: UIButton?
var circularprogressclock: CircularProgressClock?

let buttonsize: Int = 50
let southWest = CLLocationCoordinate2D(latitude: 47.407, longitude: 17.44)
let northEast = CLLocationCoordinate2D(latitude: 44.657, longitude: 12.1)
let overlayBounds = GMSCoordinateBounds(coordinate: southWest, coordinate: northEast)

class ViewControllerCountry: UIViewController, GMSMapViewDelegate {
  
    @IBOutlet weak var bottomview: UIView!
    @IBOutlet weak var mapview: GMSMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scheduledTimerWithTimeInterval()
        let (imageurls,imagetimes) = getImageUrls(type:"rain")
        arrayImages = imageurls
        arrayTimes = imagetimes
        let camera = GMSCameraPosition.camera(withLatitude: 46.018851, longitude: 14.675335, zoom: 7.1)
        self.mapview.camera = camera
        self.mapview.delegate = self
        
        // Buttons
        startstop = UIButton(frame: CGRect(x: self.view.bounds.width-100, y: self.view.bounds.height-215+65/2, width: CGFloat(buttonsize), height: CGFloat(buttonsize)))
        startstop?.setTitleColor(self.view.tintColor, for: UIControlState.normal)
        startstop?.addTarget(self, action: #selector(startstopButtonAction), for: .touchUpInside)
        if var image = UIImage(named: "stop_icon.png") {
            image =  image.resizeImage(targetSize: CGSize(width: buttonsize, height: buttonsize))
            startstop?.setImage(image, for: .normal)
        }
        self.view.addSubview(startstop!)
        
        recenter = UIButton(frame: CGRect(x: self.view.bounds.width-50, y: self.view.bounds.height-215+65/2, width: CGFloat(buttonsize), height: CGFloat(buttonsize)))
        recenter?.setTitleColor(self.view.tintColor, for: UIControlState.normal)
        recenter?.addTarget(self, action: #selector(recenterButtonAction), for: .touchUpInside)
        if var image = UIImage(named: "location_button.png") {
            image =  image.resizeImage(targetSize: CGSize(width: buttonsize, height: buttonsize))
            recenter?.setImage(image, for: .normal)
        }
        self.view.addSubview(recenter!)
        
        rainlayer = UIButton(frame: CGRect(x: self.view.bounds.width-50, y: self.view.bounds.height-300, width: CGFloat(buttonsize), height: CGFloat(buttonsize)))
        rainlayer?.setTitleColor(self.view.tintColor, for: UIControlState.normal)
        rainlayer?.addTarget(self, action: #selector(rainButtonAction), for: .touchUpInside)
        if var image = UIImage(named: "slo_rain.png") {
            image =  image.resizeImage(targetSize: CGSize(width: buttonsize, height: buttonsize))
            rainlayer?.setImage(image, for: .normal)
        }
        self.view.addSubview(rainlayer!)
        
        cloudslayer = UIButton(frame: CGRect(x: self.view.bounds.width-50, y: self.view.bounds.height-350, width: CGFloat(buttonsize), height: CGFloat(buttonsize)))
        cloudslayer?.setTitleColor(self.view.tintColor, for: UIControlState.normal)
        cloudslayer?.addTarget(self, action: #selector(cloudButtonAction), for: .touchUpInside)
        if var image = UIImage(named: "slo_clouds.png") {
            image =  image.resizeImage(targetSize: CGSize(width: buttonsize, height: buttonsize))
            cloudslayer?.setImage(image, for: .normal)
        }
        self.view.addSubview(cloudslayer!)
        
        haillayer = UIButton(frame: CGRect(x: self.view.bounds.width-50, y: self.view.bounds.height-400, width: CGFloat(buttonsize), height: CGFloat(buttonsize)))
        haillayer?.setTitleColor(self.view.tintColor, for: UIControlState.normal)
        haillayer?.addTarget(self, action: #selector(hailButtonAction), for: .touchUpInside)
        if var image = UIImage(named: "slo_hail.png") {
            image =  image.resizeImage(targetSize: CGSize(width: buttonsize, height: buttonsize))
            haillayer?.setImage(image, for: .normal)
        }
        self.view.addSubview(haillayer!)
        
        displaycamras = UIButton(frame: CGRect(x: self.view.bounds.width-50, y: self.view.bounds.height-450, width: CGFloat(buttonsize), height: CGFloat(buttonsize)))
        displaycamras?.setTitleColor(self.view.tintColor, for: UIControlState.normal)
        displaycamras?.addTarget(self, action: #selector(camerasButtonAction), for: .touchUpInside)
        if var image = UIImage(named: "slo_cctv") {
            image =  image.resizeImage(targetSize: CGSize(width: buttonsize, height: buttonsize))
            displaycamras?.setImage(image, for: .normal)
        }
        self.view.addSubview(displaycamras!)
        // Buttons - end
        
        circularprogressclock = CircularProgressClock(frame: CGRect(x: self.view.bounds.width/2-65/2, y: self.view.bounds.height-220+65/2, width: 65, height: 65))
        self.view.addSubview(circularprogressclock!)
   
    }

    @objc func startstopButtonAction(sender: UIButton!) {
        startStopAction()
    }
    
    @objc func recenterButtonAction(sender: UIButton!) {
        let camera = GMSCameraPosition.camera(withLatitude: 46.018851, longitude: 14.675335, zoom: 7.1)
        self.mapview.camera = camera
    }
    @objc func rainButtonAction(sender: UIButton!) {
        let (imageurls,imagetimes) = getImageUrls(type: "rain")
        arrayImages = imageurls
        arrayTimes = imagetimes
        //startStopAction()
    }
    @objc func cloudButtonAction(sender: UIButton!) {
        let (imageurls,imagetimes) = getImageUrls(type: "clouds")
        arrayImages = imageurls
        arrayTimes = imagetimes
        //startStopAction()
    }
    @objc func hailButtonAction(sender: UIButton!) {
        let (imageurls,imagetimes) = getImageUrls(type: "hail")
        arrayImages = imageurls
        arrayTimes = imagetimes
        //startStopAction()
    }
    @objc func camerasButtonAction(sender: UIButton!) {
        startStopAction()
        self.mapview.clear()
        let URL = "https://opendata.si/promet/cameras/"
        Alamofire.request(URL).responseObject { (response: DataResponse<CameraWrapper>) in
            let weatherResponse = response.result.value
            for x in (weatherResponse?.Contents?.first?.Data?.Items)!
            {
                let position = CLLocationCoordinate2D(latitude: x.y_wgs,longitude: x.x_wgs)
                let marker = GMSMarker(position: position)
                marker.userData = x.camera?.first?.image
                marker.title = x.title
                marker.map = self.mapview
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getImageUrls(type: String) -> ([String],[String])
    {
        var imageUrls = [String]()
        var imageTimes = [String]()
        var baseUrl = ""
        var date = Date()
        let imageCount = 11.0
        let formatter1 = DateFormatter()
        let formatter2 = DateFormatter()
        formatter1.dateFormat = "yyyyMMdd-HHmm"
        formatter2.dateFormat = "HH:mm"
        formatter1.timeZone = TimeZone(abbreviation: "UTC")
        let timeZone = TimeZone.autoupdatingCurrent.identifier as String
        formatter2.timeZone = TimeZone(identifier: timeZone)
        
        //get date in UTC
        let gregorian = Calendar(identifier: .gregorian)
        let now = Date()
        var components = gregorian.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        let minutes = components.minute!
        
        switch type {
        case "rain":
            baseUrl = "http://meteo.arso.gov.si/uploads/probase/www/nowcast/inca/inca_si0zm_"
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
            date = gregorian.date(from: components)!
            date.addTimeInterval(-imageCount * 10.0 * 60.0)
            date.addTimeInterval(20*60)
        case "clouds":
            baseUrl = "http://www.meteo.si/uploads/probase/www/nowcast/inca/inca_sp_"
            if (minutes >= 0 && minutes <= 31)
            {
                components.hour = (components.hour!-1)
                components.minute = 30
            }
            if (minutes >= 31 && minutes <= 60)
            {
                components.minute = 0
            }
            date = gregorian.date(from: components)!
            date.addTimeInterval(-imageCount * 30.0 * 60.0)
        case "hail":
            baseUrl = "http://www.meteo.si/uploads/probase/www/nowcast/inca/inca_hp_";
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
            date = gregorian.date(from: components)!
            date.addTimeInterval(-imageCount * 10.0 * 60.0)
            date.addTimeInterval(20*60)
        default:
            print("Couldn't find appropriate layer")
        }
        
        for _ in 0...Int(imageCount)
        {
            let formattedDate = formatter1.string(from: date)
            let theUrl = baseUrl + formattedDate + "+0000.png";
            imageUrls.append(theUrl)
            imageTimes.append(formatter2.string(from: date))
            switch type {
            case "rain":
                date.addTimeInterval(10.0 * 60)
            case "hail":
                date.addTimeInterval(10.0 * 60)
            case "clouds":
                date.addTimeInterval(30.0 * 60)
            default:
                print("Couldn't find appropriate layer")
            }
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
            circularprogressclock?.progress = CGFloat(ind*10)
            circularprogressclock?.title = arrayTimes[ind]
            let proc = TopBottomProcessor()
            //let proc2 = RoundCornerImageProcessor()
            KingfisherManager.shared.retrieveImage(with: url!, options: [.processor(proc)], progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                
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
            if var image = UIImage(named: "start_icon.png") {
                image =  image.resizeImage(targetSize: CGSize(width: buttonsize, height: buttonsize))
                startstop?.setImage(image, for: .normal)
            }
        }
        else
        {
            scheduledTimerWithTimeInterval()
            if var image = UIImage(named: "stop_icon.png") {
                image =  image.resizeImage(targetSize: CGSize(width: buttonsize, height: buttonsize))
                startstop?.setImage(image, for: .normal)
            }
        }
        isRunning = !isRunning
    }
    
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        let alert = UIAlertController(title: marker.title, message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertActionStyle.default, handler: nil))
    
        let imageView = UIImageView(frame: CGRect(x: 10, y: 50, width: alert.view.bounds.size.width - 10 * 4.0, height: alert.view.bounds.size.width-50))
 
        let url = URL(string: marker.userData as! String)
        imageView.kf.setImage(with: url, options: [.forceRefresh])
        alert.view.addSubview(imageView)
        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: self.view.frame.height * 0.55)
        
        alert.view.addConstraint(height)
        self.present(alert, animated: true, completion: nil)
        
        return true
    }
}

extension UIImage {
    
    func resizeImage(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
