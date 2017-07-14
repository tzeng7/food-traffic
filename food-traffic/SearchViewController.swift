//
//  SearchViewController.swift
//  food-traffic
//
//  Created by Kevin Tzeng on 7/12/17.
//  Copyright © 2017 Kevin Tzeng. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    var arr = ["Tacos?", "Asian?", "Boba?", "Fast Food?", "Italian?"]
    var index = 0

    @IBOutlet weak var suggestionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        self.suggestionLabel.text = self.arr[self.index%5]
        self.index+=1
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseIn], animations: {
            self.suggestionLabel.alpha = 1.0
        }, completion: {(Bool) -> Void in self.repeatFadeIn()})
        
        
    }
}

