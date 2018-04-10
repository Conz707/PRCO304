//
//  CreateStudentViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 26/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import Alamofire

class CreateStudentViewController: UIViewController,  UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, URLSessionTaskDelegate, URLSessionDelegate, URLSessionDataDelegate {

    @IBOutlet var imgStudent: UIImageView!
    @IBOutlet var txtKeyPerson: UITextField!
    @IBOutlet var txtGuardian: UITextField!
    @IBOutlet var txtFather: UITextField!
    @IBOutlet var txtMother: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var txtSurname: UITextField!
    @IBOutlet var txtFirstName: UITextField!
    var StudentID = 0
    var image = #imageLiteral(resourceName: "placeholder.png")

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imgStudent.isUserInteractionEnabled = true
        imgStudent.addGestureRecognizer(tapGestureRecognizer)
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
            imgStudent.image = image
        } else {
            print("error using image")//error message
        }
        self.dismiss(animated: true, completion: nil)
        
    }

    func getMaxStudentID(completion: @escaping (_ success: Bool) -> ()){
        var success = true
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/GetMaxStudentID.php")!)
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
            self.StudentID = Int(responseString)! + 1
            print("student id is: \(self.StudentID)")
            if(self.StudentID == 0){
                success = false
            }
            DispatchQueue.main.async{
                completion(success)
            }
        }
        task.resume()
        print(success)
    }
    
    
    @IBAction func finalizeCreation(_ sender: Any) {
        
        if((txtMother.text?.isEmpty)! && (txtFather.text?.isEmpty)! && (txtGuardian.text?.isEmpty)!){
            print("empty fields")
        } else {
        
        DispatchQueue.main.async {
            self.getMaxStudentID(completion: { success in
            let firstName = self.txtFirstName.text
            let surname = self.txtSurname.text
            let dateOfBirth = self.datePicker.date
            let mother = self.txtMother.text
            let father = self.txtFather.text
            let guardian = self.txtGuardian.text
                print(self.StudentID)

            let keyPerson = self.txtKeyPerson.text
            var studentPicture = "https://shod-verses.000webhostapp.com/students/\((self.StudentID))/DisplayPictures/\((firstName!) + (surname!)).jpg"
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/CreateStudent.php")!)
        
        request.httpMethod = "POST"
        
        let postString = "FirstName=\(firstName!)&Surname=\(surname!)&DateOfBirth=\(dateOfBirth)&Mother=\(mother!)&Father=\(father!)&Guardian=\(guardian!)&KeyPerson=\(keyPerson!)&StudentPicture=\(studentPicture)&Student_ID=\(self.StudentID)"
        
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
            self.upload(image: self.imgStudent.image!, studentFirstName: firstName!, studentSurname: surname!)
            })
        }
    }
    }
    
    
    func upload(image: UIImage, studentFirstName: String, studentSurname: String){
        guard let imageData = UIImageJPEGRepresentation(imgStudent.image!, 0.5) else {
            print("could not get jpeg of image")
            return
        }
        
        
        let parameters = ["studentID": "\(StudentID)"]
        print(parameters)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file",fileName: "\((studentFirstName) + (studentSurname) + ".jpg")", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to:"https://shod-verses.000webhostapp.com/ProfileImageUpload.php")
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


