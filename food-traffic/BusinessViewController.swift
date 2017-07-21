//
//  BusinessViewController.swift
//  food-traffic
//
//  Created by Kevin Tzeng on 7/13/17.
//  Copyright © 2017 Kevin Tzeng. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import AlamofireImage

class BusinessViewController: UIViewController {
    
    var business: Business?
    var yesTapped = 0
    var noTapped = 0
    @IBOutlet weak var restaurantLabel: UILabel!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    
    override func viewDidLoad() {
        self.restaurantLabel.text = self.business?.id
        let url = self.business?.image_url
        restaurantImage?.af_setImage(withURL: URL(string: url!)!)
        super.viewDidLoad()
    }
    
    @IBAction func yesButtonTapped(_ sender: UIButton) {
        yesTapped += 1
    }
    @IBAction func noButtonTapped(_ sender: UIButton) {
        noTapped += 1
    }
    
}
