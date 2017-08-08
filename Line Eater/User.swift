//
//  User.swift
//  
//
//  Created by Kevin Tzeng on 7/27/17.
//
//

import Foundation
import Foundation
import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject, NSCoding {
    // MARK: - Properties
    
    let uid: String
    
    // MARK: - Init
    
    init(uid: String) {
        self.uid = uid
        super.init()
    }
    
    //Failable initializer.
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
            let username = dict["username"]
            else {
                return nil //Failable!
        }
        self.uid = snapshot.key
        super.init()
    }
    
    // MARK: - Singleton
    
    private static var _current: User?
    
    static var current: User {
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        return currentUser
    }
    
    // MARK: - Class Methods
    static func setCurrent(_ user: User, writeToDefaults: Bool = false) {
        if writeToDefaults {
            //We use NSKeyedArchiver to turn our user object into Data. We needed to implement the NSCoding protocol and inherit from NSObject to use NSKeyedArchiver.
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            //We store the data for our current user with the correct key in UserDefaults.
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        _current = user
        
    }
    
    //MARK: - NSCoding protocol
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String
            else { return nil }
        
        self.uid = uid

        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey: Constants.UserDefaults.uid)
    }
}
