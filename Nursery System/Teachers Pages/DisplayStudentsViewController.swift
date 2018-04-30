//
//  AllStudents.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 10/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import Foundation

class StudentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
        @IBOutlet weak var tblAllStudents: UITableView!
        @IBOutlet var activityIndicatorTableLoading: UIActivityIndicatorView!
        @IBOutlet var segmentedAgeGroups: UISegmentedControl!
        var postString = ""
        var students = [Student]()
        var defaultValues = UserDefaults.standard
        var U_ID = ""
        var feedItems: NSArray = NSArray()
        var selectedStudent : Student = Student()

        
        override func viewDidLoad() {
            super.viewDidLoad()
            U_ID = defaultValues.string(forKey: "UserU_ID")!

            activityIndicatorTableLoading.hidesWhenStopped = true
            activityIndicatorTableLoading.startAnimating()

            
        }
    @IBAction func segmentChangeTable(_ sender: Any) {
            activityIndicatorTableLoading.startAnimating()
    
       switch segmentedAgeGroups.selectedSegmentIndex {
        case 0:
         postString = "DisplayStudents=All"
         print(postString)
        case 1:
         postString = "DisplayStudents=AgeGroupA"
         print(postString)
        case 2:
         postString = "DisplayStudents=AgeGroupB"
         print(postString)
        case 3:
         postString = "DisplayStudents=AgeGroupC"
         print(postString)
        case 4:
         postString = "U_ID=\(U_ID)&DisplayStudents=KeyStudents"
         print(postString)
            
       default:
        segmentedAgeGroups.selectedSegmentIndex = 0
        print("default")
        }
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetStudents.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)

       let postRequest = utilities.postRequest(postString: postString, request: request, completion: { success, data in
            do {
                self.students = try JSONDecoder().decode(Array<Student>.self, from: data)
                for eachStudent in self.students {
                    print("\(eachStudent.description)")
                }
            } catch {
                print(error)
                print("ERROR")
            }
            DispatchQueue.main.async {
                self.itemsDownloaded(items: self.students as NSArray)
                print("trying to print items downloaded \(self.students)")
            }
        
          })
    
    }
    
        override func viewDidAppear(_ animated: Bool) {
            
            segmentChangeTable((Any).self)
        
        }
        
        func itemsDownloaded(items: NSArray){
            feedItems = items
            self.tblAllStudents.reloadData()
            activityIndicatorTableLoading.stopAnimating()
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
            let item: Student = feedItems[indexPath.row] as! Student
            //get references to labels of cells
            
            let URL_IMAGE = URL(string: (item.StudentPicture)!)
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
                                myCell.textLabel!.text = item.FirstName! + " " + item.Surname!
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
            selectedStudent = feedItems[indexPath.row] as! Student
            //Manually call segue to detail view controller
            self.performSegue(withIdentifier: "StudentSegue", sender: self)
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            //get reference to destination view controller
            let studentVC = segue.destination as! StudentDetailsViewController
            //set property to selected student so when view loads, it accesses the properties of feeditem obj
            studentVC.selectedStudent = selectedStudent
            
            print("finding the list of activities")
            print(selectedStudent.description)
            
        }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    }


