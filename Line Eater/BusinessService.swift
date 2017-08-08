//
//  BusinessService.swift
//  food-traffic
//
//  Created by Kevin Tzeng on 7/21/17.
//  Copyright © 2017 Kevin Tzeng. All rights reserved.
//

import Foundation
import FirebaseDatabase
import UIKit
import FirebaseStorage
import SwiftyJSON

class BusinessService {
    
    
    static func updateRating (_ business: Business , rating: CLong, completion: @escaping (Business?) -> Void) {
        let attributes = ["rating": rating  , "time": ServerValue.timestamp() ] as [String : Any] //sets user to encompass dictionary
        
        let ref = Database.database().reference().child("businesses").child(business.realID) //sets reference to firUser uid
        let autoRef = ref.childByAutoId ()
        autoRef.setValue(attributes) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
        }
    }
    
    static func getRatings (completion: @escaping (CLong) -> Void) {
        let ref = Database.database().reference().childByAutoId() //sets reference to firUser uid
        
        let dict = ["time": ServerValue.timestamp()]
        ref.setValue(dict)
        ref.child("time").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let currentTime = snapshot.value as? CLong else {
                return
            }
            completion(currentTime)
            ref.removeValue()
            })
        
        
       
    }
    
    static func queryLastHour (_ businessId: String, startTime: CLong, endTime: CLong, completion: @escaping (DataSnapshot) -> Void) {
        let ref = Database.database().reference().child("businesses").child(businessId) //sets reference to firUser uid
        
        ref.queryOrdered(byChild: "time").queryStarting(atValue: startTime).queryEnding(atValue: endTime).observe(.value, with: completion)
    }
}
