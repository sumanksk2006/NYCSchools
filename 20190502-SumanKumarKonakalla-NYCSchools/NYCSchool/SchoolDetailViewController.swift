//
//  SchoolDetailViewController.swift
//  NYCSchool
//
//  Created by Suman Kumar Konakalla on 5/2/19.
//  Copyright © 2019 My Org. All rights reserved.
//

import UIKit

class SchoolDetailViewController: UIViewController {

    @IBOutlet weak var readingAvgResult: UILabel!
    @IBOutlet weak var writingAvgResult: UILabel!
    @IBOutlet weak var mathAvgResult: UILabel!
    @IBOutlet weak var SATTakersResult: UILabel!
    @IBOutlet weak var schoolOverview: UITextView!
    @IBOutlet weak var schoolTitle: UILabel!
    var selectedSchool : School?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "SAT Results"
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.schoolOverview.layer.borderWidth = 2.0
        self.schoolOverview.layer.borderColor = UIColor.gray.cgColor
        self.schoolOverview.layer.cornerRadius = 5.0

        self.SATTakersResult.text = ": \(selectedSchool?.SATTakers ?? 0)"
        self.writingAvgResult.text = ": \(selectedSchool?.writngAvg ?? 0)"
        self.readingAvgResult.text = ": \(selectedSchool?.readingAvg ?? 0)"
        self.mathAvgResult.text = ": \(selectedSchool?.mathAvg ?? 0)"
        self.schoolOverview.text = selectedSchool?.overview
        self.schoolTitle.text = selectedSchool?.schoolName
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
