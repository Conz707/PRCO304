//
//  CreateActivityViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 19/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import Alamofire


class CreateActivityViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, URLSessionTaskDelegate, URLSessionDelegate, URLSessionDataDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var progressIndicatorUpload: UIProgressView!
    @IBOutlet var dateActivity: UIDatePicker!
    @IBOutlet var txtStudentObservation: UITextView!
    @IBOutlet var txtStudentActivity: UITextField!
    @IBOutlet var lblStudentName: UILabel!
    @IBOutlet var imgActivity: UIImageView!
    @IBOutlet var txtDropdown: UITextField!
    @IBOutlet var pickerDropdown: UIPickerView!
    var responseSuccess = false
    var selectedStudent : Student = Student()
    var NewActivityID = 0
    var goals = [Goal]()
    var ageGroup = ""
    var ageGroupGoals = ""
    var selectedGoalID = ""
    var postString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        switch(ageGroup){       //set age group for finding students goals
        case "A":
            ageGroupGoals = "AgeGroupAGoals"
            break
        case "B":
            ageGroupGoals = "AgeGroupBGoals"
            break
        case "c":
            ageGroupGoals = "AgeGroupCGoals"
            break
        default:
            break
        }
        
        getGoalsDropdown()      //get list of students goals for the drop down
        
        txtStudentActivity.autocapitalizationType = .words
        txtStudentObservation.autocapitalizationType = .sentences
        
        let minDate = Calendar.current.date(byAdding: .month, value: -18, to: Date())
        dateActivity.minimumDate = minDate // 18Months
        dateActivity.maximumDate = Date() //todays date
        
        lblStudentName.text = selectedStudent.FirstName! + " " + selectedStudent.Surname!
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))      //set a variable to recognize tap gestures and run image tapped
  
        imgActivity.isUserInteractionEnabled = true
        imgActivity.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
            progressIndicatorUpload.isHidden = true
            progressIndicatorUpload.setProgress(0, animated: true)
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.goals.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return "\(goals[row].Goal!)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {        //selected goals fill in the text box
        if (goals.count > 0 && goals.count >= row){
            self.txtDropdown.text = "\(goals[row].Goal!)"
            selectedGoalID = goals[row].G_ID!
            self.pickerDropdown.isHidden = true
        }
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == self.txtDropdown){    //ask nick about this
            self.pickerDropdown.isHidden = false
            self.view.endEditing(true)
        }
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){       //if image tapped run the utility for picking image
        let image = UIImagePickerController()
        image.delegate = self
       
        let utilImageTapped = utilities.imageTapped(image: image, sender: self)
        

        self.present(utilImageTapped, animated: true)
    }
 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{ //check if using image possible
            imgActivity.image = image
        } else {
            print("error using image")//error message
        }
        self.dismiss(animated: true, completion: nil)
        
    }


    
    @IBAction func btnSaveActivity(_ sender: Any) {
        if(txtStudentObservation.text.isEmpty == false && txtStudentActivity.text?.isEmpty == false){
        DispatchQueue.main.async {
            self.getMaxActivityID { success in
        
        let alertSave = UIAlertController(title: "Create this Activity?", message: nil, preferredStyle: .actionSheet)
        
        alertSave.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
        
            //for creating activity
            let activity = self.txtStudentActivity.text
            let observation = self.txtStudentObservation.text
            let date = self.dateActivity.date
            let S_ID = self.selectedStudent.S_ID!
            let activityPicture = "https://shod-verses.000webhostapp.com/students/\((self.selectedStudent.S_ID!))/ActivityPictures/\(self.NewActivityID).jpg"
            
            //used for emailing parents/guardians
            let student = (self.selectedStudent.FirstName!) + " " + (self.selectedStudent.Surname!)
            let studentMother = self.selectedStudent.Mother ?? ""
            let studentFather = self.selectedStudent.Father ?? ""
            let studentGuardian = self.selectedStudent.Guardian ?? ""
            
            
            var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/SaveActivity.php")!)
            
            request.httpMethod = "POST"
            if(self.txtDropdown.text?.isEmpty)!{        //if text bos is empty then goal hasnt been completed with challenge, so dont mark it in database
                self.postString = ("A_ID=\(self.NewActivityID)&S_ID=\(S_ID)&Activity=\(activity!)&Observation=\(observation!)&Date=\(date)&ActivityPicture=\(activityPicture)&SelectedStudent=\(student)&Mother=\(studentMother)&Father=\(studentFather)&Guardian=\(studentGuardian)&NotificationActivityID=\(self.NewActivityID)&AgeGroupGoals=\(self.ageGroupGoals)")
                } else {                        //otherwse goal has been met, mark this in database
                self.postString = ("A_ID=\(self.NewActivityID)&S_ID=\(S_ID)&Activity=\(activity!)&Observation=\(observation!)&Date=\(date)&ActivityPicture=\(activityPicture)&SelectedStudent=\(student)&Mother=\(studentMother)&Father=\(studentFather)&Guardian=\(studentGuardian)&NotificationActivityID=\(self.NewActivityID)&G_ID=\(self.selectedGoalID)&AgeGroupGoals=\(self.ageGroupGoals)")
                }
            
            request.httpBody = self.postString.data(using: .utf8)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {                                                 // check for fundamental networking error
                    print("error=\(error)")
        
                    return
                }
                
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(response)")
                    
                }
                
                let responseString = String(data: data, encoding: .utf8)!
                print("responseString = \(responseString)")
                if(responseString == "Record inserted successfully"){
                    self.responseSuccess = true
                    
                }
        
            }
            task.resume()
            self.progressIndicatorUpload.isHidden = false
            self.upload(image: self.imgActivity.image!)
        }))
        
        alertSave.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alertSave.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertSave, animated: true, completion: nil)
                }
            }
        } else {
            self.present(utilities.normalAlertBox(alertTitle: "Error", messageString: "Ensure no fields are empty"), animated: true)
        }
    }
    
    func getMaxActivityID(completion: @escaping (_ success: Bool) -> ()){       //get max activity id for naming the image within the ftp
        //Get max activity id +1
        var success = true
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/GetMaxActivityID.php")!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {                                                 // check for fundamental networking error
                print("error=\(error)")
                success = false
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            var responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(responseString)")
            if(responseString != ""){
            self.NewActivityID = Int(responseString)! + 1
            } else {
                responseString = "1"
            }
            if(self.NewActivityID == 0){
                success = false
            }
            DispatchQueue.main.async{
                completion(success)
            }
        }
        task.resume()
        print(success)
    
    }
    
    func getGoalsDropdown(){            //get a students goals for dropdown menu
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/GetGoalsDropdown.php")!)
        request.httpMethod = "POST"
        let postString = ("S_ID=\(selectedStudent.S_ID!)&AgeGroupGoals=\(ageGroupGoals)")
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
            do {
                self.goals = try JSONDecoder().decode(Array<Goal>.self, from: data)
            } catch {
                print(error)
                print("ERROR")
            }
            DispatchQueue.main.async {
                self.pickerDropdown.reloadComponent(0)
            }
            
        })
    }
    
    func upload(image: UIImage){         //upload image to FTP
        guard let imageData = UIImageJPEGRepresentation(imgActivity.image!, 0.5) else {
            print("could not get jpeg of image")
            return
        }

            let parameters = ["studentID": "\(self.selectedStudent.S_ID!)"]
        print(parameters)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file",fileName: "\((String(self.NewActivityID)) + ".jpg")", mimeType: "image/jpg")   //upload to ftp in multipart form JPEG with student name as file name
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to:"https://shod-verses.000webhostapp.com/ImageUpload.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):         //if successful
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    self.progressIndicatorUpload.setProgress(Float(progress.fractionCompleted), animated: true)
                    DispatchQueue.main.async {
                        if(progress.fractionCompleted == 1.0){
                            let alertUploadSuccess = UIAlertController(title: "Successfully created activity", message: nil, preferredStyle: .actionSheet)
                            
                            alertUploadSuccess.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                                self.navigationController?.popViewController(animated: true)
                            }))
                            
                            if let popoverController = alertUploadSuccess.popoverPresentationController {
                                popoverController.sourceView = self.view
                                popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                                popoverController.permittedArrowDirections = []
                            }
                            
                            self.present(alertUploadSuccess, animated: true, completion: nil)
                        }
                    }

                })
                
                upload.responseString { response in
                    print(response.result.value)
                }
                
            case .failure(let encodingError):         //if failed uploading
                print(encodingError)
                
                
            }
        }
    }
    

    
    
}
