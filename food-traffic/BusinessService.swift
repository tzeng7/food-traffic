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
                return completion(nil)
            }
            
        }
    }
    
    static func getRatings (_ business: Business) {
        let ref = Database.database().reference().childByAutoId() //sets reference to firUser uid
        
        let key = ref.key
        let dict = ["time": ServerValue.timestamp()]
        ref.setValue(dict)
        ref.child("time").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? CLong
            print (value)
            }
        )
    }
}
