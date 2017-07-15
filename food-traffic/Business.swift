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
    var is_closed: Bool
    var image_url: String
    var location: String
    var distance: Double

    
    init (json: JSON) {
        self.id = json["name"].stringValue
        self.is_closed = json["is_closed"].boolValue
        self.image_url = json["image_url"].stringValue
        self.location = "\(json["location"]["display_address"][0]), \(json["location"]["display_address"][1])"
        self.distance = json["distance"].doubleValue
    }
    
    
    
   // for busy places - maybe implement google api but for smaller places - rely on user interaction
    
}
