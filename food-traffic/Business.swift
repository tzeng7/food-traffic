//
//  Business.swift
//  food-traffic
//
//  Created by Kevin Tzeng on 7/13/17.
//  Copyright © 2017 Kevin Tzeng. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Business {
    //variables for everything that i need (all optionals)
    var id: String
    var realID: String
    var is_closed: Bool
    var image_url: String
    var location: String
    var distance: Double
    var type: String
    
    init (json: JSON) {
        self.id = json["name"].stringValue
        self.realID = json["id"].stringValue
        self.is_closed = json["is_closed"].boolValue
        self.image_url = json["image_url"].stringValue
        self.location = "\(json["location"]["display_address"][0]), \(json["location"]["display_address"][1])"
        self.distance = json["distance"].doubleValue * 0.000621371
        var value: [String] = []
        for (_, subJson) in json["categories"] {
            if let title = subJson["title"].string {
                value.append(title)
            }
        }
        let joiner = ", "
        self.type = value.joined(separator: joiner)
        //
    }
     //

    
    
   // for busy places - maybe implement google api but for smaller places - rely on user interaction
    
}
