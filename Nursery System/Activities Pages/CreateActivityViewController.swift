//
//  CreateActivityViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 19/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import Alamofire


class CreateActivityViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, URLSessionTaskDelegate, URLSessionDelegate, URLSessionDataDelegate {
    
    @IBOutlet var progressIndicatorUpload: UIProgressView!
    @IBOutlet var dateActivity: UIDatePicker!
    @IBOutlet var txtStudentObservation: UITextView!
    @IBOutlet var txtStudentActivity: UITextField!
    @IBOutlet var lblStudentName: UILabel!
    @IBOutlet var imgActivity: UIImageView!
    var responseSuccess = false
    var selectedStudent : StudentsModel = StudentsModel()   //WHY???
    var image = #imageLiteral(resourceName: "placeholder.png")
    var NewActivityID = 0

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let minDate = Calendar.current.date(byAdding: .month, value: -18, to: Date())
        dateActivity.minimumDate = minDate // 18Months
        dateActivity.maximumDate = Date() //todays date //this datepicker kinda sucks, try to fix
        
        lblStudentName.text = selectedStudent.firstName! + " " + selectedStudent.surname!
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
  
        imgActivity.isUserInteractionEnabled = true
        imgActivity.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
            progressIndicatorUpload.isHidden = true
    }
    
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print("image tapped")
        let image = UIImagePickerController()  //handles stuff that lets user interact with image
        image.delegate = self

        let alertImageTapped = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alertImageTapped.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            image.sourceType = UIImagePickerControllerSourceType.camera
            image.allowsEditing = false
            self.present(image, animated: true)
        }))
        
        alertImageTapped.addAction(UIAlertAction(title: "Choose from Photo Library", style: .default, handler: { _ in
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary  //pick image from ipad camera roll
            image.allowsEditing = true //hmm
            self.present(image, animated: true, completion: nil)
        }))
        
        alertImageTapped.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alertImageTapped.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alertImageTapped, animated: true, completion: nil)
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
       
        DispatchQueue.main.async {
            self.getMaxActivityID { success in
        
        let alertSave = UIAlertController(title: "Create this Activity?", message: nil, preferredStyle: .actionSheet)
        
        alertSave.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
        
            let activity = self.txtStudentActivity.text
            let observation = self.txtStudentObservation.text
            let date = self.dateActivity.date
            let S_ID = self.selectedStudent.studentID!
            let activityPicture = "https://shod-verses.000webhostapp.com/students/\((self.selectedStudent.studentID!))/ActivityPictures/\(self.NewActivityID).jpg"
            
            var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/SaveActivity.php")!)
            
            request.httpMethod = "POST"
            
            let postString = ("S_ID=\(S_ID)&Activity=\(activity!)&Observation=\(observation!)&Date=\(date)&ActivityPicture=\(activityPicture)")
            
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
    }
    
    func getMaxActivityID(completion: @escaping (_ success: Bool) -> ()){
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
            self.NewActivityID = Int(responseString)! + 1
            print("student id is: \(self.NewActivityID)")
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
    
    func upload(image: UIImage){
        guard let imageData = UIImageJPEGRepresentation(imgActivity.image!, 0.5) else {
            print("could not get jpeg of image")
            return
        }

            let parameters = ["studentID": "\(self.selectedStudent.studentID!)"]
        print(parameters)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file",fileName: "\((String(self.NewActivityID)) + ".jpg")", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to:"https://shod-verses.000webhostapp.com/ImageUpload.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
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
                
            case .failure(let encodingError):
                print(encodingError)
                
                
            }
        }
    }
}
