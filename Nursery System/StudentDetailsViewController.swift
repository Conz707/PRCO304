//
//  StudentDetailsViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 06/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//
import Foundation
import UIKit

class StudentDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LoadActivitiesModelProtocol {

    var selectedStudent : StudentsModel?
    var feedItems: NSArray = NSArray()
    let loadActivitiesModel = LoadActivitiesModel()
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblMother: UILabel!
    @IBOutlet weak var lblKeyPerson: UILabel!
    @IBOutlet weak var lblGuardian: UILabel!
    @IBOutlet weak var lblFather: UILabel!
    @IBOutlet var lblAgeGroup: UILabel!
    @IBOutlet var tblActivities: UITableView!
    var selectedActivity : ActivitiesModel = ActivitiesModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

      
        self.tblActivities.delegate = self
        self.tblActivities.dataSource = self
        
        loadActivitiesModel.downloadItems()
        loadActivitiesModel.delegate = self
        
       
        
        lblName.text = (selectedStudent?.firstName)! + " " + (selectedStudent?.surname)!
        lblMother.text = selectedStudent?.mother
        lblFather.text = selectedStudent?.father
        lblGuardian.text = selectedStudent?.guardian
        lblKeyPerson.text = selectedStudent?.keyPerson
      //  lblID.text = selectedStudent?.studentID
        
        
      //  var dateFormatter = DateFormatter()
     //   var displayDOB = dateFormatter.string(from: (selectedStudent?.dateOfBirth)!)
      //  lblDateOfBirth.text = displayDOB
        
     //   lblDateOfBirth.text = selectedStudent?.dateOfBirth as? [String: AnyObject]
        //This needs to pull key person from staff database based on ID
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
  /*  func checkStudentActivities(completion: @escaping (_ success: Bool) -> ()){
        var success = true
        
        let s_ID = selectedStudent?.studentID
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/LoadActivities.php")!)
        request.httpMethod = "POST"
        let postString = ("a=1")
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                
            }
            
            var responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(responseString)")
            if(responseString == ""){
                success = false
            } else {
                success = true
                
            }
            completion(success)
        }
        task.resume()

    }

    
*/
    
            
            
            // Do any additional setup after loading the view.
    
    
        func itemsDownloaded(items: NSArray){
            feedItems = items
            self.tblActivities.reloadData()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //return num of feed items
            return feedItems.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //retrieve cell
            let cellIdentifier: String = "BasicCell"
            let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
            
            
            
            //get activity to show
            let item: ActivitiesModel = feedItems[indexPath.row] as! ActivitiesModel
            //get references to labels of cells
            myCell.textLabel!.text = item.activity
            
            return myCell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {     //whenever user taps row

            //set selected activity to var
            selectedActivity = feedItems[indexPath.row] as! ActivitiesModel
            //manually call segue to detail view controller
            self.performSegue(withIdentifier: "viewActivity", sender: self)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //get reference to destination view controller
     //   let activityVC = segue.destination as! ActivityDetailsViewController
        //set property to selected activity so when view loads, it accesses the properties of feeditem obj
       // activityVC.selectedActivity = selectedActivity
        
    }
    
    
    
    
}
