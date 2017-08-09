    //
//  BusinessesViewController.swift
//  food-traffic
//
//  Created by Kevin Tzeng on 7/13/17.
//  Copyright © 2017 Kevin Tzeng. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Alamofire
import AlamofireImage
class BusinessesViewController: UITableViewController {

    var businesses: [Business]?
    var entry: String?
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    override func viewDidLoad() {
        let sharedInstance = YelpAPIService.sharedInstance
        if let entry = entry {
            sharedInstance.getBusinesses(term: entry, longitude: String(longitude), latitude: String(latitude), sort_by: "distance"){ (businesses) in
                
                self.businesses = businesses
                self.recalculateBusy()
            }
        }
        
        
        //sharedInstance.getBusinesses(term: "Thai", longitude: "-121.97158380000002", latitude: "37.3179792"){ (businesses) in self.businesses = businesses
            
            
        print("Calling viewDidLoad")
        super.viewDidLoad()
            // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.recalculateBusy()
        super.viewDidAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if let businessCheck = businesses {
            return businessCheck.count
        } else {
            return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "businessCell", for: indexPath) as! BusinessCell
        let row = indexPath.row
        if let businessCheck = businesses {
            let business = businessCheck[row]
            cell.distanceLabel.text =
                "\(String(round(100*business.distance)/100)) mi"
            cell.addressLabel.text = business.location
            cell.addressLabel.adjustsFontSizeToFitWidth = true
            
            let thumbnail = cell.thumbImage
            let url = business.image_url
            if url != "" {
                thumbnail!.af_setImage(withURL: URL(string: url)!)
            }
            
            
            cell.businessLabel.text = business.id
            cell.typeLabel.text = business.type
            cell.checkInLabel.text = business.busy.rawValue
            if cell.checkInLabel.text == "Busy" {
                cell.checkInLabel.textColor = UIColor.red
                cell.checkInLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
            } else if cell.checkInLabel.text == "Not Busy" {
                cell.checkInLabel.textColor = UIColor(rgb: 0x009900)
                cell.checkInLabel.font = UIFont.boldSystemFont(ofSize: 12.0)


            } else if cell.checkInLabel.text == "No Data" {
                cell.checkInLabel.textColor = UIColor.black
                cell.checkInLabel.font = UIFont.systemFont(ofSize: 12.0)

            }
        }
        
        return cell
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if identifier == "displayRestaurant" {
                let indexPath = tableView.indexPathForSelectedRow
                let businessViewController = segue.destination as! BusinessViewController
                businessViewController.business = businesses![indexPath!.row]
            }
        }
    }
    
    func recalculateBusy() -> Void {
        BusinessService.getRatings() { (currentTime) in
            
            let hourAgoTime = currentTime - 3600000
            guard self.businesses != nil else {
                return
            }
            for (index, business) in self.businesses!.enumerated() {
                BusinessService.queryLastHour(business.realID, startTime: hourAgoTime, endTime: currentTime) {
                    (snapshot) in
                    print("Index: \(index) BusinessId: \(snapshot.ref.description())")
                    var noBusy = 0
                    var yesBusy = 0
                    for ratingEntry in snapshot.children {
                        if let ratingEntry = ratingEntry as? DataSnapshot {
                            guard let dict = ratingEntry.value as? [String: Any],
                                let ratingValue = dict["rating"] as? Int else {
                                    return
                            }
                            if ratingValue == 1 {
                                yesBusy += 1
                            } else {
                                noBusy += 1
                            }
                        }
                    }
                    if yesBusy == 0 && noBusy == 0 {
                        self.businesses?[index].busy = .noData
                    } else if yesBusy >= noBusy {
                        self.businesses?[index].busy = .busy
                    } else {
                        self.businesses?[index].busy = .notBusy
                    }
                    self.tableView.reloadData()
                    
                }
            }
            
        }
    }
   

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
