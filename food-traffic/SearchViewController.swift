//
//  SearchViewController.swift
//  food-traffic
//
//  Created by Kevin Tzeng on 7/12/17.
//  Copyright © 2017 Kevin Tzeng. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {

    var arr = ["Tacos?", "Boba?", "Fast Food?", "Italian?", "Indian?", "Mediterranean?", "Thai?", "Japanese?", "Mexican?", "Chinese?"]
    var index = 0
    var entry: String = ""

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var suggestionLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchField.delegate = self

        repeatFadeIn()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func repeatFadeIn() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn], animations:  {
            self.suggestionLabel.alpha = 0.0
        }, completion: {(Bool) -> Void in self.fadeOut()})
    }
    
    func fadeOut() {
        self.suggestionLabel.text = self.arr[self.index%arr.count]
        self.index+=1
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn], animations: {
            self.suggestionLabel.alpha = 1.0
        }, completion: {(Bool) -> Void in self.repeatFadeIn()})
        
        
    }
    
    func textFieldShouldReturn(_ searchField: UITextField) -> Bool {
        self.view.endEditing(true)
        self.entry = self.searchField.text!
        performSegue(withIdentifier: "toBusinessesList", sender: searchField)
        resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "toBusinessesList" {
                let BusinessesViewController = segue.destination as! BusinessesViewController
            }
       }
    }
 }
