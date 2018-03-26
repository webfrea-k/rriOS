//
//  Camera.swift
//  Rain Radar
//
//  Created by Simon Hočevar on 26/03/2018.
//  Copyright © 2018 Simon Hočevar. All rights reserved.
//

import Foundation
import ObjectMapper

class CameraWrapper: Mappable {
    var Contents: [Contents]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        Contents <- map["Contents"]
    }
}

class Contents: Mappable {
    var Data: Data?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        Data <- map["Data"]
    }
}

class Data: Mappable {
    var Items: [Items]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        Items <- map["Items"]
    }
}

class Items: Mappable {
    
    var y_wgs: Double!
    var x_wgs: Double!
    var description: String?
    var title: String?
    var camera: [Camera]?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        description <- map["Description"]
        x_wgs <- map["x_wgs"]
        y_wgs <- map["y_wgs"]
        title <- map["Title"]
        camera <- map["Kamere"]
    }
}





class Camera: Mappable {
    var text: String?
    var image: String?
    var region: String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        text <- map["Text"]
        image <- map["Image"]
        region <- map["Region"]

    }
}






