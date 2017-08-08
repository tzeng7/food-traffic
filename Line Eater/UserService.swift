//
//  UserService.swift
//  Pods
//
//  Created by Leslie Tzeng on 7/27/17.
//
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

struct UserService {
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        let userAttrs = ["username": username]
        
        let ref = Database.database().reference().child("users").child(firUser.uid)
        
        
        // write to database
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            // read from database and create Makestagam.User
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                
                // handle newly created user here
                completion(user)
            })
        }
        
    }
    static func show(forUID uid: String, completion: @escaping (User?) -> Void) {
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            
            completion(user)
        })
    }
}
