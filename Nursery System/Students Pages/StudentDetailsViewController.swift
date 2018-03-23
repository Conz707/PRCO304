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
 //   let loadActivitiesModel = LoadActivitiesModel()
    
    
    @IBOutlet var imgStudent: UIImageView!
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
        
        let URL_IMAGE = URL(string: (selectedStudent?.displayPicture)!)
        print(URL_IMAGE)
        let session = URLSession(configuration: .default)
        
        //create a dataTask
        let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { data, response, error in
        
           //if error
            if let e = error {
                //display message
                print("Error occurred: \(e)")
            } else {
                if (response as? HTTPURLResponse) != nil {
                    
                    //check response contains image
                    if let imageData = data {
                        
                        //get image
                        let image = UIImage(data: imageData)
                        
                        //display the image
                        DispatchQueue.main.async{
                        self.imgStudent.image = image
                            }
                        } else {
                        print("image corrupted")
                        }
                    } else {
                        print("No server response")
                    }
                }
            }
            getImageFromUrl.resume()
      
        
                self.tblActivities.dataSource = self
                self.tblActivities.delegate = self
                
                let loadActivitiesModel = LoadActivitiesModel()
                loadActivitiesModel.downloadItems()
                loadActivitiesModel.delegate = self

        


        lblName.text = (selectedStudent?.firstName)! + " " + (selectedStudent?.surname)!
        
        //TEST TEST TEST FIX MOTHER FATHER GUARDIAN KEYPERSON TO PULL THE NAMES FROM OTHER TABLES
        //lblMother.text = selectedStudent?.mother
        //lblFather.text = selectedStudent?.father
        //lblGuardian.text = selectedStudent?.guardian
        //lblKeyPerson.text = selectedStudent?.keyPerson
        //lblID.text = selectedStudent?.studentID
        //var dateFormatter = DateFormatter()
        //var displayDOB = dateFormatter.string(from: (selectedStudent?.dateOfBirth)!)
        //lblDateOfBirth.text = displayDOB
        //lblDateOfBirth.text = selectedStudent?.dateOfBirth as? [String: AnyObject]
        //This needs to pull key person from staff database based on ID
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
        func itemsDownloaded(items: NSArray){
            feedItems = items
            tblActivities.reloadData()
            
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
                let item: ActivitiesModel = self.feedItems[indexPath.row] as! ActivitiesModel
 
                    print("attempting to attach activity to table")
            
            
            let URL_IMAGE = URL(string: (item.activityPicture)!)
            print(URL_IMAGE)
            let session = URLSession(configuration: .default)
            
            //create a dataTask
            let getImageFromUrl = session.dataTask(with: URL_IMAGE!) { data, response, error in
                
                //if error
                if let e = error {
                    //display message
                    print("Error occurred: \(e)")
                } else {
                    if (response as? HTTPURLResponse) != nil {
                        
                        //check response contains image
                        if let imageData = data {
                            
                            //get image
                            let image = UIImage(data: imageData)
                            print("image", image)
                            print(URL_IMAGE)
                            //display the image
                            DispatchQueue.main.async{
                                myCell.textLabel!.text = item.activity
                                myCell.imageView?.image = image
                            }
                        } else {
                            print("image corrupted")
                        }
                    } else {
                        print("No server response")
                    }
                }
            }
            getImageFromUrl.resume()
            return myCell
    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {     //whenever user taps row

            //set selected activity to var
            selectedActivity = feedItems[indexPath.row] as! ActivitiesModel
            //manually call segue to detail view controller
            self.performSegue(withIdentifier: "viewActivity", sender: self)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if (segue.identifier == "viewActivity"){
        //get reference to destination view controller
      let viewActivityVC = segue.destination as! ActivityDetailsViewController
        //set property to selected activity so when view loads, it accesses the properties of feeditem obj
        viewActivityVC.selectedActivity = selectedActivity
        } else if (segue.identifier == "createActivity"){
            //get reference to destination view controller
            let createActivityVC = segue.destination as! CreateActivityViewController
            //set property to selected student so when view loads, it accesses the properties of feeditem obj ??
            createActivityVC.selectedStudent = selectedStudent!
            
        }
    }
    
    
    
    
}
