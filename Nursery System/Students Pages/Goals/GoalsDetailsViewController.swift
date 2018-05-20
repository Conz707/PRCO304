//
//  GoalsDetailsViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 01/05/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class GoalsDetailsViewController: UIViewController {

    @IBOutlet var txtGoal: UITextField!
    @IBOutlet var lblStudent: UILabel!
    var selectedGoal : Goal = Goal()
    var selectedStudent : Student = Student()
    var postString = ""
    var ageGroup = ""
    var ageGroupGoals = ""
    var completed = false
    @IBOutlet var btnGoalCompletedOutlet: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        txtGoal.text = selectedGoal.Goal
        lblStudent.text = "\(selectedStudent.FirstName!) \(selectedStudent.Surname!)"
        // Do any additional setup after loading the view.
        

        
        
        switch(ageGroup){       //set and display goals from the appropriate age group
        case "A":
            ageGroupGoals = "AgeGroupAGoals"
            break
        case "B":
            ageGroupGoals = "AgeGroupBGoals"
            break
        case "C":
            ageGroupGoals = "AgeGroupCGoals"
            break
        default:
            break
        }
        
        
        checkGoalCompleted { success in     //check if goal completed or not and set the check box appropriately
            if(self.completed == true){
                self.btnGoalCompletedOutlet.setImage(UIImage(named: "checked box"), for: .normal)
            } else {
                self.btnGoalCompletedOutlet.setImage(UIImage(named: "unchecked box"), for: .normal)
            }
            
        }
        
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnGoalCompleted(_ sender: Any) {        //set the box to the opposite of its current state
        if(completed == true){
            btnGoalCompletedOutlet.setImage(UIImage(named: "unchecked box"), for: .normal)
            completed = false
        } else {
            btnGoalCompletedOutlet.setImage(UIImage(named: "checked box"), for: .normal)
            completed = true
        }
    }
    
    @IBAction func btnSaveChanges(_ sender: Any) {
        if(txtGoal.text?.isEmpty == false){
        editAlert()
        } else {
            
            self.present(utilities.normalAlertBox(alertTitle: "Error", messageString: "Ensure goal contains text"), animated: true)

        }
        
    }
    
    @IBAction func btnDeleteGoal(_ sender: Any) {
        
       deleteAlert()
        
    }
    
    func editGoal(){        //after confirming save changes
        
        var goalCompleted = 0
        
        if(completed == true){      //if goal marked as complete, set to 1 and send that to db
            goalCompleted = 1
        }
        
        postString = "AgeGroupGoals=\(ageGroupGoals)&G_ID=\(selectedGoal.G_ID!)&Goal=\(txtGoal.text!)&Completed=\(goalCompleted)"
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/EditGoal.php")!)
        request.httpMethod = "POST"
                request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request) { success, data, responseString in
        }
        
    }
    
    func deleteGoal(){      //if confirm delete goal
        
        postString = "AgeGroupGoals=\(ageGroupGoals)&G_ID=\(selectedGoal.G_ID!)"
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/DeleteGoal.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request) { success, data, responseString in
        }
        
    }
    
    func deleteAlert(){
        let alert = UIAlertController(title: "Confirm Delete Goal - This action can NOT be undone.", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            //delete activity
            self.deleteGoal()
            
            let alertDeleteSuccess = UIAlertController(title: "Successfully deleted goal", message: nil, preferredStyle: .actionSheet)
            
            //return view
            alertDeleteSuccess.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            
            if let popoverController = alertDeleteSuccess.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(alertDeleteSuccess, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }

    func editAlert(){
        let alert = UIAlertController(title: "Confirm Save Goal Changes.", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            //delete activity
            self.editGoal()
            
            let alertDeleteSuccess = UIAlertController(title: "Successfully updated goal", message: nil, preferredStyle: .actionSheet)
            
            //return view
            alertDeleteSuccess.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            
            if let popoverController = alertDeleteSuccess.popoverPresentationController {
                popoverController.sourceView = self.view
                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
            
            self.present(alertDeleteSuccess, animated: true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }

    
    func postRequest(postString: String, request: URLRequest, completion: @escaping (_ success : Bool) -> ()){  //extends postrequest but dk how to do that using utilities
        var success = true
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
                success = false
            }
            
            let responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(responseString)")
            if(responseString == "true"){
                self.completed = true
            } else {
                self.completed = false
            }
            DispatchQueue.main.async{
                completion(success)
            }
        }
        task.resume()
    }
    
    func checkGoalCompleted(completion: @escaping (_ success : Bool) -> ()){        //run on entering page, check whether goal is completed and make appropriate changes to page
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/CheckGoalCompleted.php")!)
        request.httpMethod = "POST"
        
        let postString = ("AgeGroupGoals=\(ageGroupGoals)&G_ID=\(selectedGoal.G_ID!)")
        request.httpBody = postString.data(using: .utf8)
        
        postRequest(postString: postString, request: request, completion: { success in
            completion(success)
        })
        
    }

    
}
