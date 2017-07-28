//
//  YelpAPIService.swift
//  food-traffic
//
//  Created by Kevin Tzeng on 7/13/17.
//  Copyright © 2017 Kevin Tzeng. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
//read on how to authorize alamofire http request - how to add oauth
//how to add query parameters 
//read alamofire call to see how to construct

class YelpAPIService {
    static let sharedInstance = YelpAPIService()
    
    let endpoint = "https://api.yelp.com/v3/businesses/search"
    var sessionManager:Alamofire.SessionManager
    
    init() {
        sessionManager = SessionManager()
        //For now, hardcode the access token. Eventually we can store it in Firebase and 
        //add logic to generate the access token if it doesn't work:
        //https://github.com/Alamofire/Alamofire#requestadapter
        
        sessionManager.adapter = AccessTokenAdapter(accessToken: "4elowsw_YbRTD7EqvAj6RFip3fEcfOvIFakJ8M0PMozPvfKRtOBOPEg325U3CmMotrvuj_QMOMAeYOFzsvU3UcoyH1Uo_9B4A74yrG3M0uDCUXeoLqcIO5Dn811oWXYx")
    }
    
    //Ideally this would be called by the ViewController and would
    
    func getBusinesses(term: String, longitude: String, latitude: String, sort_by: String, completion: @escaping (([Business]?) -> Void)) {
        let parameters:[String: String] = ["term":term, "longitude":longitude, "latitude":latitude, "sort_by":sort_by ]
        
        sessionManager.request(endpoint, method: .get, parameters: parameters).validate().responseJSON() { response in
            switch response.result {
            case .success:
                if let value = response.result.value {
                    let json = JSON(value)
                    // Do what you need to with JSON here!
                    // The rest is all boiler plate code you'll use for API requests
                    print(json)
                    // Do conversion using json
                    //Either write the converter here or do it elsewhere.
//                    let businesses:[Business] = convert(json)
//
//                    completion(businesses)
                    let businessData = json["businesses"].arrayValue
                    //print (businessData)
                    var businesses: [Business] = []
                    for business in businessData {
                        let business = Business(json: business)
                        businesses.append(business)
                    }
                    print (businesses)
                    completion(businesses)
                    
                    
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //Write a parser/converter
    
    
    
    
    
}
