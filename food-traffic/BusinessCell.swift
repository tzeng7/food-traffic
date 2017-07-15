//
//  Business.swift
//  food-traffic
//
//  Created by Kevin Tzeng on 7/13/17.
//  Copyright © 2017 Kevin Tzeng. All rights reserved.
//

import Foundation
import UIKit

class BusinessCell: UITableViewCell {
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var ratingImage: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var businessLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var checkInLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
}
