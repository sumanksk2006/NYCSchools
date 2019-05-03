//
//  SchoolListTableViewCell.swift
//  NYCSchool
//
//  Created by Suman Kumar Konakalla on 5/2/19.
//  Copyright © 2019 My Org. All rights reserved.
//

import UIKit
import SafariServices

class SchoolListTableViewCell: UITableViewCell {

    @IBOutlet weak var mapPoint: UIButton!
    @IBOutlet weak var website: UIButton!
    @IBOutlet weak var phoneNumber: UIButton!
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var schoolName: UILabel!
    
    var latitude:String? = ""
    var longitude:String? = ""
    var delegate:SchoolsListViewController? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func phoneClicked(_ sender: Any) {
        let telephone = self.phoneNumber.titleLabel?.text?.replacingOccurrences(of: "-", with: "")
        
        if telephone?.count == 10 {
            if UIApplication.shared.canOpenURL(URL(string: "tel://\(telephone!)")!) {
                UIApplication.shared.open(URL(string: "tel://\(telephone!)")!)
            }
        }
    }
    
    @IBAction func websiteClicked(_ sender: Any) {
        if self.website.titleLabel?.text?.count ?? 0 > 0 {
            let websiteLink = "http://" + (self.website.titleLabel?.text ?? "")
          
            guard let websiteURL = URL(string: websiteLink) else{
                return
            }
            
            let safariVC = SFSafariViewController(url: websiteURL)
            
            if delegate != nil {
                delegate?.present(safariVC, animated: true, completion: nil)
            }
        }
        
    }
    @IBAction func mapClicked(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapVC = storyboard.instantiateViewController(withIdentifier: "mapViewID") as! MapKitViewController
        if delegate != nil {
            /*mapVC.schoolLatitude = (self.latitude as NSString?)?.doubleValue
            mapVC.schoolLongitude = (self.longitude as NSString?)?.doubleValue*/
            
            mapVC.schoolLocation = CLLocationCoordinate2D(latitude: (self.latitude as NSString?)!.doubleValue, longitude: (self.longitude as NSString?)!.doubleValue)
            mapVC.primaryAddress = self.address.text ?? "Address"
            mapVC.schoolName = self.schoolName.text ?? "School Name"
            delegate?.navigationController?.pushViewController(mapVC, animated: true)
        }
    }
    
}
