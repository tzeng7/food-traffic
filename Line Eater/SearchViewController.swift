//
//  SearchViewController.swift
//  food-traffic
//
//  Created by Kevin Tzeng on 7/12/17.
//  Copyright © 2017 Kevin Tzeng. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase
import FirebaseAuthUI
import FirebaseAuth
import FirebaseAnalytics

class SearchViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate {

    var arr = ["Tacos?", "Boba?", "Fast Food?", "Italian?", "Indian?", "Mediterranean?", "Thai?", "Japanese?", "Mexican?", "Chinese?"]
    var index = 0
    var latitude = 0.0
    var longitude = 0.0
    var term: String?
    var terms: [String]?
    let locationMgr = CLLocationManager()
    @IBOutlet weak var searchField: AutoCompleteTextField!
    @IBOutlet weak var suggestionLabel: UILabel!
    @IBOutlet weak var peopleGif: UIImageView!
    var responseData:NSMutableData?
    var dataTask:URLSessionDataTask?
    
    @IBAction func logOutButtonTapped(_ sender: UIButton) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "loggedin")
        UserDefaults.standard.synchronize()
        let storyboard = UIStoryboard(name: "Login", bundle: .main)
        if let initialViewController = storyboard.instantiateInitialViewController() {
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }

    }

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //configureTextField()
        handleTextFieldInterfaces()
        getLocation()
        self.searchField.delegate = self
        peopleGif.loadGif(name: "giphy")
        repeatFadeIn()
        

        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        searchField.text = ""
        super.viewDidAppear(animated)
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
    
    func configureTextField(){
        searchField.autoCompleteTextFont = UIFont(name: "Helvetica", size: 12.0)!
        searchField.autoCompleteCellHeight = 35.0
        searchField.maximumAutoCompleteCount = 20
        searchField.hidesWhenSelected = true
        searchField.hidesWhenEmpty = true
        searchField.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.black
        attributes[NSFontAttributeName] = UIFont(name: "Helvetica", size: 12.0)
        searchField.autoCompleteAttributes = attributes
    }
    
    func handleTextFieldInterfaces(){
        searchField.onTextChange = {[weak self] text in
            print (text)
            if !text.isEmpty{
                if let dataTask = self?.dataTask {
                    dataTask.cancel()
                }
                let sharedInstance = YelpAPIService.sharedInstance
                print ("hi")
                sharedInstance.autocomplete(text: text)
                    { (terms) in
                        print ("result")
                        print(terms)
                        self?.terms = terms
                        self?.searchField.autoCompleteStrings = terms
                    }
                    
                }
        }
        searchField.onSelect = {[weak self] text, indexpath in
            self?.searchField.text = text
            }
    }


 }
