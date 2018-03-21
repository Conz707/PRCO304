//
//  CreateActivityViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 19/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class CreateActivityViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var dateActivity: UIDatePicker!
    
    @IBOutlet var txtStudentObservation: UITextView!
    @IBOutlet var txtStudentActivity: UITextField!

    @IBOutlet var lblStudentName: UILabel!
    
    @IBOutlet var imgOne: UIImageView!
    @IBOutlet var imgTwo: UIImageView!
    @IBOutlet var imgThree: UIImageView!
    var selectedStudent : StudentsModel = StudentsModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStudentName.text = selectedStudent.firstName! + " " + selectedStudent.surname!

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imgOne.isUserInteractionEnabled = true
        imgOne.addGestureRecognizer(tapGestureRecognizer)
        imgTwo.isUserInteractionEnabled = true
        imgTwo.addGestureRecognizer(tapGestureRecognizer)
        imgThree.isUserInteractionEnabled = true
        imgThree.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
     print("sssssss")
        let tappedImage = tapGestureRecognizer.view as! UIImageView
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
    @IBAction func btnSaveActivity(_ sender: Any) {
        let activity = txtStudentActivity.text
        let observation = txtStudentObservation.text
        let date = dateActivity.date
        let S_ID = selectedStudent.studentID!
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/SaveActivity.php")!)
      
        request.httpMethod = "POST"
       
        let postString = ("S_ID=\(S_ID)&Activity=\(activity!)&Observation=\(observation!)&Date=\(date)")
       
        print(postString)
        
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

        }
        task.resume()
    }
}
