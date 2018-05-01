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
    var postString = ""
    var ageGroup = ""
    var ageGroupRequest = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtGoal.text = selectedGoal.Goal
        // Do any additional setup after loading the view.
        print(selectedGoal.description)
        print(ageGroup)
        
        switch(ageGroup){
        case "a":
            print("a")
            ageGroupRequest = "AgeGroupA"
            break
        case "b":
            print("b")
            ageGroupRequest = "AgeGroupB"
            break
        case "c":
            print("c")
            ageGroupRequest = "AgeGroupC"
            break
        default:
            break
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnSaveChanges(_ sender: Any) {
        if(txtGoal.text?.isEmpty == false){
        editAlert()
        } else {
            
            let alertController = UIAlertController(title: "Error", message: "Ensure goal contains text", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func btnDeleteGoal(_ sender: Any) {
        
       deleteAlert()
        
    }
    
    func editGoal(){
        
        postString = "G_ID=\(selectedGoal.G_ID!)&Goal=\(txtGoal.text!)"
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/EditGoal.php")!)
        request.httpMethod = "POST"
                request.httpBody = postString.data(using: .utf8)
        
        let postRequest = utilities.postRequest(postString: postString, request: request) { success, data in
        }
        
    }
    
    func deleteGoal(){
        
        postString = "G_ID=\(selectedGoal.G_ID!)"
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/DeleteGoal.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        print(postString)
        
        let postRequest = utilities.postRequest(postString: postString, request: request) { success, data in
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
        let alert = UIAlertController(title: "Confirm Save Goal Changes - This action can NOT be undone.", message: nil, preferredStyle: .actionSheet)
        
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

    
    
}
