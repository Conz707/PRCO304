//
//  AllStudents.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 10/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import Foundation

class StudentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    @IBOutlet weak var btnAddUserOutlet: UIButton!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet weak var tblAllStudents: UITableView!
        @IBOutlet var activityIndicatorTableLoading: UIActivityIndicatorView!
        @IBOutlet var segmentedAgeGroups: UISegmentedControl!
        var postString = ""
        var students = [Student]()
        var defaultValues = UserDefaults.standard
        var U_ID = ""
        var feedItems: NSArray = NSArray()
        var filterStudents = [Student]()
        var selectedStudent : Student = Student()
    
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
      
            if(defaultValues.string(forKey: "UserRole") == "Manager"){      //manager only function
                btnAddUserOutlet.isHidden = false
            } else {
                btnAddUserOutlet.isHidden = true
            }
            
            U_ID = defaultValues.string(forKey: "UserU_ID")!

            activityIndicatorTableLoading.hidesWhenStopped = true
            activityIndicatorTableLoading.startAnimating()
            
        }
    
    @IBAction func segmentChangeTable(_ sender: Any) {
            activityIndicatorTableLoading.startAnimating()
    
       switch segmentedAgeGroups.selectedSegmentIndex {
        case 0:
         postString = "DisplayStudents=All"
        case 1:
         postString = "DisplayStudents=AgeGroupA"
        case 2:
         postString = "DisplayStudents=AgeGroupB"
        case 3:
         postString = "DisplayStudents=AgeGroupC"
        case 4:
         postString = "U_ID=\(U_ID)&DisplayStudents=KeyStudents"
            
       default:
        segmentedAgeGroups.selectedSegmentIndex = 0
        }
        
        decodeStudent(postString: postString)
    }
    
    func decodeStudent(postString: String){     //decode student into struct for use
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetStudents.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString  in
            do {
                self.students = try JSONDecoder().decode(Array<Student>.self, from: data)
            } catch {
                print(error)
                print("ERROR")
            }
            DispatchQueue.main.async {
                self.itemsDownloaded(items: self.students as NSArray)
            }
            
        })
    }
    
        override func viewDidAppear(_ animated: Bool) {
            
            segmentChangeTable((Any).self)
            selectedStudent = Student()
        
        }
        
        func itemsDownloaded(items: NSArray){   //once items downloaded perform these tasks
            feedItems = items
            filterStudents = items as! [Student]
            self.tblAllStudents.reloadData()
            activityIndicatorTableLoading.stopAnimating()
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            //return num of feed items
     
            return filterStudents.count
        }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {    //adding cell properties to table
        //retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        
        //get students
        let item: Student = filterStudents[indexPath.row]
        
        utilities.getImages(URL_IMAGE: URL(string: (item.StudentPicture)!)!, completion: { success, image in
            
            //display the cells
            DispatchQueue.main.async{
                myCell.textLabel!.text = item.FirstName! + " " + item.Surname!
                myCell.imageView?.image = image
            }
        })
        
        return myCell
        
    }
    

        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {     //whenever user taps row perform actions
            //set selected student to var
            selectedStudent = filterStudents[indexPath.row]
            //Manually call segue to detail view controller
            self.performSegue(withIdentifier: "StudentSegue", sender: self)
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {    //filter students when text entered / deleted
        guard !searchText.isEmpty else {
            filterStudents = students
            tblAllStudents.reloadData()
            return
            
        }
        filterStudents = students.filter({ student -> Bool in
            
             student.FirstName!.lowercased().contains(searchText.lowercased()) || student.Surname!.lowercased().contains(searchText.lowercased())
        })
        tblAllStudents.reloadData()
    }
    

    

        override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //prepare the next view by sending  the selected student
            
            if(segue.identifier == "StudentSegue"){
            //get reference to destination view controller
            let studentVC = segue.destination as! StudentDetailsViewController
            //set property to selected student so when view loads, it accesses the properties of feeditem obj
            studentVC.selectedStudent = selectedStudent
            } else {
            let createStudentVC = segue.destination as! CreateOrEditStudentViewController
            createStudentVC.selectedStudent = selectedStudent
            }
            
        }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    
    

    
}


