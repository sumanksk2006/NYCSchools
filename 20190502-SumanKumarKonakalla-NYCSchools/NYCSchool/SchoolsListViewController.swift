//
//  ViewController.swift
//  NYCSchool
//
//  Created by Suman Kumar Konakalla on 5/2/19.
//  Copyright © 2019 My Org. All rights reserved.
//

import UIKit

class SchoolsListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBOutlet weak var NYCSplashView: UIImageView!
    @IBOutlet weak var schoolSearchBar: UISearchBar!
    var schools : [School] = []
    var filteredSchools: [School] = []

    @IBOutlet weak var schoolsListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "NYC SCHOOLS"
        self.navigationController?.navigationBar.isHidden = true
        self.fetchSchools()
        self.schoolsListTableView.estimatedRowHeight = 160.0
        self.schoolsListTableView.rowHeight = UITableView.automaticDimension
        // Do any additional setup after loading the view.
    }


    //MARK: Fetch Data
    func fetchSchools() {
        WebServiceHandler().getListOfSchools(urlString: schoolsListAPI) { (schools, errorMssg) in
            if errorMssg != "" {
                let alertController = self.presentAlertController(alertTitle: "NYC Schools", alertMessage: errorMssg, okButtonString: "Ok", cancelButtonString: "")
                self.present(alertController,animated: true,completion: nil)
                return
            }
            
            if let fetchedSchools = schools {
                self.schools = fetchedSchools
                self.filteredSchools = fetchedSchools
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                    self.NYCSplashView.removeFromSuperview()
                    self.navigationController?.navigationBar.isHidden = false
                    self.schoolsListTableView.reloadData()
                }
            }
        }
    }
    
    func fetchSchoolDetails(selectedSchool: School){
        WebServiceHandler().getSchoolDetail(urlString: schoolDetailAPI, selectedSchool: selectedSchool) {  (school, errorMssg) in
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                if errorMssg != "" {
                    let alertController = self.presentAlertController(alertTitle: "NYC Schools", alertMessage: errorMssg, okButtonString: "Ok", cancelButtonString: "")
                    self.present(alertController,animated: true,completion: nil)
                    return
                }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let schoolDetailVC = storyboard.instantiateViewController(withIdentifier: "schoolDetail") as! SchoolDetailViewController
                schoolDetailVC.selectedSchool = selectedSchool
                self.navigationController?.pushViewController(schoolDetailVC, animated: true)
            }
        }
    }
    
    
    //MARK: AlertController
    func presentAlertController(alertTitle: String, alertMessage: String, okButtonString: String, cancelButtonString: String) -> UIAlertController {
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        if !cancelButtonString.isEmpty {
            let cancelAction = UIAlertAction(title: cancelButtonString, style: .cancel, handler: { UIAlertAction in
            })
            alertController.addAction(cancelAction)
        }
        if !okButtonString.isEmpty {
            let okAction = UIAlertAction(title: okButtonString, style: .default, handler: { UIAlertAction in
            })
            alertController.addAction(okAction)
        }
        
        return alertController
    }
    
    //MARK: Tableview DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredSchools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = SchoolListTableViewCell()
        if let schoolCell = tableView.dequeueReusableCell(withIdentifier: "school"){
            cell = schoolCell as! SchoolListTableViewCell
        }
        else{
            cell = SchoolListTableViewCell(style: .default, reuseIdentifier: "school")
        }
        cell.delegate = self
        let schoolObj = self.filteredSchools[indexPath.row]
        cell.schoolName.text = schoolObj.schoolName
        cell.address.text = schoolObj.primaryAddress + "\n" + schoolObj.city + "," + schoolObj.statecode + " " + schoolObj.postcode
        
        cell.phoneNumber.setTitle(schoolObj.phone, for: .normal)
        cell.website.setTitle(schoolObj.website, for: .normal)
        cell.latitude = schoolObj.latitude
        cell.longitude = schoolObj.longitude
        
        if let _ = Double(schoolObj.latitude), let _ = Double(schoolObj.longitude)  {
            cell.mapPoint.isHidden = false
        }
        else{
            cell.mapPoint.isHidden = true
        }
        cell.accessoryType = .disclosureIndicator
        return cell
        
    }
    
    //MARK: Tableview Delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.indicator.startAnimating()
        self.fetchSchoolDetails(selectedSchool: self.filteredSchools[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - SearchBar Delegate Methods
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        
        let regEx = "[A-Za-z0-9\\s]"
        var regExValidation : Bool = true
        if text.count > 0 {
            if let textPredicate = NSPredicate(format: "SELF MATCHES %@", regEx) as NSPredicate? {
                regExValidation = textPredicate.evaluate(with: text)
            }
        }
        
        if regExValidation {
            return true
        }
        else{
            return false
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.resignFirstResponder()
        
    }
    
    func searchSchools(searchText : String){
        if !(searchText.count == 0){
            
            let searchResults = self.schools.filter { (schoolObj: School) -> Bool in
                schoolObj.schoolName.localizedCaseInsensitiveContains(searchText)
            }
            
            
            self.filteredSchools = searchResults
            self.schoolsListTableView.reloadData()
            
        }
        else{
            self.filteredSchools = self.schools
            self.schoolsListTableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        self.searchSchools(searchText: searchText)
        
        if searchText.count == 0 {
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.filteredSchools = self.schools
        self.schoolsListTableView.reloadData()
    }
    

}

