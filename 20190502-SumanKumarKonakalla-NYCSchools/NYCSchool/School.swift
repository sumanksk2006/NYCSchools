//
//  School.swift
//  NYCSchool
//
//  Created by Suman Kumar Konakalla on 5/2/19.
//  Copyright © 2019 My Org. All rights reserved.
//

import Foundation

class School {
    let dbn: String
    let schoolName: String
    let overview: String
    let phone: String
    let schoolEmail: String
    let website: String
    let primaryAddress: String
    let city: String
    let postcode: String
    let statecode: String
    let latitude: String
    let longitude: String
    var SATTakers: Int = 0
    var readingAvg: Int = 0
    var writngAvg: Int = 0
    var mathAvg: Int = 0
    
    init(schoolDict: [String:Any]){
        self.dbn = (schoolDict["dbn"] ?? "") as! String
        self.schoolName = (schoolDict["school_name"] ?? "") as! String
        self.overview = (schoolDict["overview_paragraph"] ?? "") as! String
        self.phone = (schoolDict["phone_number"] ?? "") as! String
        self.schoolEmail = (schoolDict["school_email"] ?? "") as! String
        self.website = (schoolDict["website"] ?? "") as! String
        self.primaryAddress = (schoolDict["primary_address_line_1"] ?? "") as! String
        self.city = (schoolDict["city"] ?? "") as! String
        self.postcode = (schoolDict["zip"] ?? "") as! String
        self.statecode = (schoolDict["state_code"] ?? "") as! String
        self.latitude = (schoolDict["latitude"] ?? "") as! String
        self.longitude = (schoolDict["longitude"] ?? "") as! String
    }
}
