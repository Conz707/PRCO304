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
    
    @IBOutlet var dateActivity: UIDatePicker!
    @IBOutlet var txtStudentObservation: UITextView!
    @IBOutlet var txtStudentActivity: UITextField!
    @IBOutlet var lblStudentName: UILabel!
    @IBOutlet var imgActivity: UIImageView!
    var selectedStudent : StudentsModel = StudentsModel()
    var image = #imageLiteral(resourceName: "placeholder.png")

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblStudentName.text = selectedStudent.firstName! + " " + selectedStudent.surname!

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imgActivity.isUserInteractionEnabled = true
        imgActivity.addGestureRecognizer(tapGestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        print("image tapped")
        let image = UIImagePickerController()  //handles stuff that lets user interact with image
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary  //pick image from ipad photo library
        image.allowsEditing = false //hmm
        
        self.present(image, animated: true)
        {
            //after it is complete
            
        }
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
        let activity = txtStudentActivity.text
        let observation = txtStudentObservation.text
        let date = dateActivity.date
        let S_ID = selectedStudent.studentID!
        let activityPicture = "https://shod-verses.000webhostapp.com/students/\((selectedStudent.firstName!) + (selectedStudent.surname!))/ActivityPictures/\(activity!).jpg"
        
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
            
            var responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(responseString)")

        }
        task.resume()
        
        upload(image: imgActivity.image!, activity2: activity!)
        
    }
    
    
    func upload(image: UIImage, activity2: String){
        guard let imageData = UIImageJPEGRepresentation(imgActivity.image!, 0.5) else {
            print("could not get jpeg of image")
            return
        }
        
        
        let parameters = ["studentID": "\(selectedStudent.studentID!)"]
        print(parameters)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file",fileName: "\((activity2) + ".jpg")", mimeType: "image/jpg")
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
