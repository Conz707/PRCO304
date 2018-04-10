//
//  AllStudents.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 10/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import Foundation

class StudentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AllStudentsModelProtocol, AgeGroupAProtocol, AgeGroupBProtocol, AgeGroupCProtocol, KeyStudentsModelProtocol {
        
        @IBOutlet var activityIndicatorTableLoading: UIActivityIndicatorView!
        
    @IBOutlet var segmentedAgeGroups: UISegmentedControl!
    var feedItems: NSArray = NSArray()
        var selectedStudent : StudentsModel = StudentsModel()
        @IBOutlet weak var tblAllStudents: UITableView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            activityIndicatorTableLoading.hidesWhenStopped = true
            activityIndicatorTableLoading.startAnimating()
            navigationController?.navigationBar.isHidden = true    //stops backing too fast crashing application
            
        }
    @IBAction func segmentChangeTable(_ sender: Any) {
        
        if(segmentedAgeGroups.selectedSegmentIndex == 0){
            activityIndicatorTableLoading.startAnimating()
            let studentsModel = AllStudentsModel()
            studentsModel.delegate = self
            studentsModel.downloadItems()

            
        } else if(segmentedAgeGroups.selectedSegmentIndex == 1){
            activityIndicatorTableLoading.startAnimating()
            let studentsModel = AgeGroupAModel()
            studentsModel.delegate = self
            studentsModel.downloadItems()
        } else if(segmentedAgeGroups.selectedSegmentIndex == 2){
            activityIndicatorTableLoading.startAnimating()
            let studentsModel = AgeGroupBModel()
            studentsModel.delegate = self
            studentsModel.downloadItems()
        } else if (segmentedAgeGroups.selectedSegmentIndex == 3) {
            activityIndicatorTableLoading.startAnimating()
            let studentsModel = AgeGroupCModel()
            studentsModel.delegate = self
            studentsModel.downloadItems()
        } else {
            activityIndicatorTableLoading.startAnimating()
            let studentsModel = KeyStudentsModel()
            studentsModel.delegate = self
            studentsModel.downloadItems()
        }

    }
    
        override func viewDidAppear(_ animated: Bool) {
            
            self.tblAllStudents.delegate = self
            self.tblAllStudents.dataSource = self
            
            let homeModel = AllStudentsModel()
            homeModel.delegate = self
            homeModel.downloadItems()
            
        }
        
        func itemsDownloaded(items: NSArray){
            feedItems = items
            self.tblAllStudents.reloadData()
            activityIndicatorTableLoading.stopAnimating()
            navigationController?.navigationBar.isHidden = false
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //return num of feed items
            return feedItems.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //retrieve cell
            let cellIdentifier: String = "BasicCell"
            let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
            
            
            //get student to show
            let item: StudentsModel = feedItems[indexPath.row] as! StudentsModel
            //get references to labels of cells
            
            let URL_IMAGE = URL(string: (item.displayPicture)!)
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
                                myCell.textLabel!.text = item.firstName! + " " + item.surname!
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
            //set selected student to var
            selectedStudent = feedItems[indexPath.row] as! StudentsModel
            //Manually call segue to detail view controller
            self.performSegue(withIdentifier: "StudentSegue", sender: self)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            //get reference to destination view controller
            let studentVC = segue.destination as! StudentDetailsViewController
            //set property to selected student so when view loads, it accesses the properties of feeditem obj
            studentVC.selectedStudent = selectedStudent
            
            print("finding the list of activities")
            
            
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    }


