//
//  Y1GoalsViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 09/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//NEEDS BIG CLEANUP
//MAKE THIS CONFORM TO SELECTED STUDENT TO SEND THE ID

import UIKit


class GoalsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var lblAddGoal: UILabel!
    @IBOutlet var tblGoals: UITableView!
    @IBOutlet var activityIndicatorTableLoading: UIActivityIndicatorView!
    @IBOutlet var segmentedGoals: UISegmentedControl!
    @IBOutlet var txtGoal: UITextView!
    @IBOutlet var btnAddGoalOutlet: UIButton!
    var goals = [Goal]()
    var selectedGoal : Goal = Goal()
    var feedItems: NSArray = NSArray()
    var postString = ""
    var selectedStudent : Student = Student()
    var ageGroup = ""
    var ageGroupGoals = ""
    var defaultValues = UserDefaults.standard
    var userRole = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtGoal.autocapitalizationType = .sentences
        userRole = defaultValues.string(forKey: "UserRole")!
        if(userRole == "Parent"){
            txtGoal.isHidden = true
            btnAddGoalOutlet.isHidden = true
            lblAddGoal.isHidden = true
            
        }
        
        switch(ageGroup){       //set the age group, this willbe used to run the appropriate sql query for the age group
        case "A":
            print("a")
            print("age group \(ageGroup)")
            ageGroupGoals = "AgeGroupAGoals"
            break
        case "B":
            print("b")
            print("age group \(ageGroup)")
            ageGroupGoals = "AgeGroupBGoals"
            break
        case "c":
            print("C")
            print("age group \(ageGroup)")
            ageGroupGoals = "AgeGroupCGoals"
            break
        default:
            break
        }
            
    }
    

    
    
    @IBAction func segmentChangeTable(_ sender: Any) {      //change sql query for age group
        
        activityIndicatorTableLoading.startAnimating()
        switch segmentedGoals.selectedSegmentIndex{
        case 0:
            postString = "AgeGroupGoals=\(ageGroupGoals)&S_ID=\(selectedStudent.S_ID!)&querySelector=Upcoming"
            print(postString)
        case 1:
            postString = "AgeGroupGoals=\(ageGroupGoals)&S_ID=\(selectedStudent.S_ID!)&querySelector=Completed"
            print(postString)
        case 2:
            postString = "AgeGroupGoals=\(ageGroupGoals)&S_ID=\(selectedStudent.S_ID!)&querySelector=All"
            print(postString)
        default:
            print("default")
            segmentedGoals.selectedSegmentIndex = 0
        }
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetStudentGoals.php")!)
      //  postString = "querySelector=All&S_ID=\(selectedStudent.S_ID!)"
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
            do {
                self.goals = try JSONDecoder().decode(Array<Goal>.self, from: data)
                for eachGoal in self.goals {
                    print("\(eachGoal.description)")
                }
            } catch {
                print(error)
                print("ERROR")
            }
            DispatchQueue.main.async {
                self.itemsDownloaded(items: self.goals as NSArray)
                print("trying to print items downloaded \(self.goals)")
            }
            
        })
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
    segmentChangeTable((Any).self)
    }
    
    @IBAction func btnAddGoal(_ sender: Any) {
        if(txtGoal.text?.isEmpty == false){
            var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/CreateAgeGroupAGoal.php")!)
            request.httpMethod = "POST"
            let postString = ("S_ID=\(selectedStudent.S_ID!)&Goal=\(txtGoal.text!)")
            print(postString)
            request.httpBody = postString.data(using: .utf8)
            
            utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
                DispatchQueue.main.async{
                    self.present(utilities.normalAlertBox(alertTitle: "Success", messageString: "Successfully created goal"), animated: true)
                }
            })
            
        } else {
            
        self.present(utilities.normalAlertBox(alertTitle: "Error", messageString: "Ensure goal contains text"), animated: true)

        }
 
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        //prepare and display table
        //retrieve cell
        let cellIdentifier: String = "BasicCell"
        let myCell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!
        //get activity to show
        let item: Goal = self.feedItems[indexPath.row] as! Goal
        
        myCell.textLabel!.text = "\(item.Goal!)"
        
        return myCell
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {     //whenever user taps row
        
        if(userRole == "Parent"){
            
        } else {
        //set selected student to var
        selectedGoal = feedItems[indexPath.row] as! Goal
        //Manually call segue to detail view controller
        self.performSegue(withIdentifier: "goalDetails", sender: self)
        print("AGE GROUP \(ageGroup)")
        }
    }
    
    func itemsDownloaded(items: NSArray){
        feedItems = items
        self.tblGoals.reloadData()
        activityIndicatorTableLoading.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {     //preparing things for next view
        let goalDetailsVC = segue.destination as! GoalsDetailsViewController
        
        goalDetailsVC.selectedGoal = selectedGoal
        goalDetailsVC.selectedStudent = selectedStudent
        goalDetailsVC.ageGroup = ageGroup
    }


}

