//
//  WebServiceHandler.swift
//  NYCSchool
//
//  Created by Suman Kumar Konakalla on 5/2/19.
//  Copyright © 2019 My Org. All rights reserved.
//

import Foundation

class WebServiceHandler {
    typealias responseDict = [String: Any]
    let defaultSession = URLSession(configuration: .default)
    var urlSession : URLSessionDataTask?
    var errorMssg = ""
    
    //MARK: API Requests
    func getListOfSchools(urlString : String, completion: @escaping ([School]?, String) -> () ){
        urlSession?.cancel()
        
        guard let requestURL = URL(string: urlString) else { return }
        urlSession = defaultSession.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                self.errorMssg = error.localizedDescription
            }
            else if let data = data, let responseData = response as? HTTPURLResponse, responseData.statusCode == 200 {
                
                completion(self.parseListOfSchools(data) , self.errorMssg)
            }
        }
        
        urlSession?.resume()
        
    }
    
    func getSchoolDetail(urlString : String, selectedSchool:School, completion: @escaping (School?, String) -> () ){
        urlSession?.cancel()
        let detailURL = urlString + selectedSchool.dbn

        guard let requestURL = URL(string: detailURL) else { return }
        urlSession = defaultSession.dataTask(with: requestURL) { data, response, error in
            if let error = error {
                self.errorMssg = error.localizedDescription
                completion(nil, self.errorMssg)
            }
            else if let data = data, let responseData = response as? HTTPURLResponse, responseData.statusCode == 200 {
                
                completion(self.parseSchoolDetail(data,selectedSchool) , self.errorMssg)
            }
           
        }
        
        urlSession?.resume()
        
    }
    //MARK: - Parse Fetched Data
    
    func parseSchoolDetail(_ data: Data,_ selectedSchool: School) -> School {
        var schoolDetailArray : [responseDict]?
        
        do {
            schoolDetailArray = try JSONSerialization.jsonObject(with: data, options:[]) as? [responseDict]
            
        } catch let parserError as NSError {
            self.errorMssg = "JSONSerialization error: \(parserError.localizedDescription)"
        }
        
        if schoolDetailArray?.count == 0 {
            self.errorMssg = detailsNotFound
            return selectedSchool
        }
        
        if let satTakers = (schoolDetailArray?.last!["num_of_sat_test_takers"] as? NSString)?.integerValue {
            selectedSchool.SATTakers = satTakers
        }
        
        if let writingAvg = (schoolDetailArray?.last!["sat_writing_avg_score"] as? NSString)?.integerValue {
            selectedSchool.writngAvg = writingAvg
        }
        
        if let readingAvg = (schoolDetailArray?.last!["sat_critical_reading_avg_score"] as? NSString)?.integerValue {
            selectedSchool.readingAvg = readingAvg
        }
        
        if let mathAvg = (schoolDetailArray?.last!["sat_math_avg_score"] as? NSString)?.integerValue {
            selectedSchool.mathAvg = mathAvg
        }
    
        
        return selectedSchool
    }
    func parseListOfSchools(_ data: Data) -> [School]{
        var allSchoolsArray : [responseDict]?
        
        var fetchedSchools : [School] = []
        
        do {
            allSchoolsArray = try JSONSerialization.jsonObject(with: data, options: []) as? [responseDict]
        } catch let parserError as NSError {
            self.errorMssg = "JSONSerialization error: \(parserError.localizedDescription)"
            return fetchedSchools
        }
        
        guard let schoolsArray = allSchoolsArray else {
            self.errorMssg = schoolsNotFoundError
            return fetchedSchools
        }
        for schoolDict in schoolsArray{
            fetchedSchools.append(School.init(schoolDict: schoolDict))
        }
        return fetchedSchools
        
    }
    
    
}
