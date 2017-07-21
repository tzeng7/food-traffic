//
//  SearchViewController.swift
//  food-traffic
//
//  Created by Kevin Tzeng on 7/12/17.
//  Copyright © 2017 Kevin Tzeng. All rights reserved.
//

import UIKit
import CoreLocation
class SearchViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    var arr = ["Tacos?", "Boba?", "Fast Food?", "Italian?", "Indian?", "Mediterranean?", "Thai?", "Japanese?", "Mexican?", "Chinese?"]
    var index = 0
    var latitude = 0.0
    var longitude = 0.0
    let locationMgr = CLLocationManager()
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var suggestionLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
        self.searchField.delegate = self

        repeatFadeIn()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func repeatFadeIn() {
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveEaseIn], animations:  {
            self.suggestionLabel.alpha = 0.0
        }, completion: {(Bool) -> Void in self.fadeOut()})
    }
    
    func fadeOut() {
        self.suggestionLabel.text = self.arr[self.index%arr.count]
        self.index+=1
        UIView.animate(withDuration: 1, delay: 0.0, options: [.curveEaseIn], animations: {
            self.suggestionLabel.alpha = 1.0
        }, completion: {(Bool) -> Void in self.repeatFadeIn()})
        
        
    }
    
    func textFieldShouldReturn(_ searchField: UITextField) -> Bool {
        self.view.endEditing(true)
        performSegue(withIdentifier: "toBusinessesList", sender: searchField)
        resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toBusinessesList" {
                let businessesViewController = segue.destination as! BusinessesViewController
                businessesViewController.entry = self.searchField.text!
                businessesViewController.latitude = self.latitude
                businessesViewController.longitude = self.longitude
            }
       }
    }
    
    func getLocation() {
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationMgr.requestWhenInUseAuthorization()
            return
        }
        if status == .denied || status == .restricted {
            let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            return
        }
        locationMgr.delegate = self
        locationMgr.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last!
        self.latitude = currentLocation.coordinate.latitude
        self.longitude = currentLocation.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }
 }
