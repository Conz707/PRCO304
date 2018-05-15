//
//  CreateStudentViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 26/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import Alamofire

class CreateOrEditStudentViewController: UIViewController,  UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, URLSessionTaskDelegate, URLSessionDelegate, URLSessionDataDelegate {

    @IBOutlet var imgStudent: UIImageView!
    @IBOutlet var txtKeyPerson: UITextField!
    @IBOutlet var txtGuardian: UITextField!
    @IBOutlet var txtFather: UITextField!
    @IBOutlet var txtMother: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var txtSurname: UITextField!
    @IBOutlet var txtFirstName: UITextField!
    var responseArr: [String] = []
    var selectedStudent: Student = Student()
    var StudentID = 0
    var image = #imageLiteral(resourceName: "placeholder.png")

    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        datePicker.maximumDate = Date()
        txtFirstName.autocapitalizationType = .words
        txtSurname.autocapitalizationType = .words
        
        
        imgStudent.isUserInteractionEnabled = true
        imgStudent.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view.
        
        if(selectedStudent.FirstName != nil){   //if selected student
            DispatchQueue.main.async {
                self.getParentsLabels(completion: { success in
                    if(self.responseArr[0] != "N/A"){
                        self.txtMother.text = self.responseArr[0]
                    }
                    if(self.responseArr[1] != "N/A"){
                        self.txtFather.text = self.responseArr[1]
                    }
                    if(self.responseArr[2] != "N/A"){
                        self.txtGuardian.text = self.responseArr[2]
                    }
                    self.StudentID = Int(self.selectedStudent.S_ID!)!
                    self.txtKeyPerson.text = self.responseArr[3]
                    self.txtFirstName.text = self.selectedStudent.FirstName
                    self.txtSurname.text = self.selectedStudent.Surname
                    
                    let formatDate = utilities.formatStringToDate(dateString: self.selectedStudent.DateofBirth!)
                    
                    self.datePicker.date = formatDate
                    
                    self.getImage()
                })
            }
        }
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
            imgStudent.image = image
        } else {
            print("error using image")//error message
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func getParentsLabels(completion: @escaping(_ success : Bool) ->()){
    
    var success = true
    
    let mother = selectedStudent.Mother
    let father = selectedStudent.Father
    let guardian = selectedStudent.Guardian
    let keyPerson = selectedStudent.KeyPerson
    
    var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ManagerSidePHPFiles/GetParentsEmails.php")!)
    
    request.httpMethod = "POST"
    
    let postString = ("Mother=\(mother ?? "")&Father=\(father ?? "")&Guardian=\(guardian ?? "")&KeyPerson=\(keyPerson ?? "")")
    print(postString)
    
    request.httpBody = postString.data(using: .utf8)
    
    postRequest(postString: postString, request: request, completion: { success, data in
    completion(success)
    })
}

    func getMaxStudentID(completion: @escaping (_ success: Bool) -> ()){
        var success = true
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ManagerSidePHPFiles/GetMaxStudentID.php")!)
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
    
    
    @IBAction func btnSave(_ sender: Any) {
        
        if((txtMother.text?.isEmpty)! && (txtFather.text?.isEmpty)! && (txtGuardian.text?.isEmpty)!){
            
            
            print("empty fields")
            
            
        } else {
            
            if(selectedStudent.FirstName != nil){ //if selected student then edit student
                editStudent()
            } else {
                addStudent()
            }

        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        
        viewDidLoad()
    }
    
    
    func getImage(){
        
        let URL_IMAGE = URL(string: (selectedStudent.StudentPicture)!)
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
                            self.imgStudent.image = image
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
        if(imgStudent == nil){
            imgStudent.image = #imageLiteral(resourceName: "earlyYearsTapToChange.jpg")
        }
    }
    
    func addStudent(){
        DispatchQueue.main.async {
            self.getMaxStudentID(completion: { success in   //need to find a new student id before adding
                let firstName = self.txtFirstName.text
                let surname = self.txtSurname.text
                let dateOfBirth = self.datePicker.date
                let mother = self.txtMother.text
                let father = self.txtFather.text
                let guardian = self.txtGuardian.text
                print(self.StudentID)
                let keyPerson = self.txtKeyPerson.text
                
                var studentPicture = "https://shod-verses.000webhostapp.com/students/\((self.StudentID))/DisplayPictures/\((firstName!) + (surname!)).jpg"
                
                var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ManagerSidePHPFiles/AddOrEditStudent.php")!)
                request.httpMethod = "POST"
                let postString = "AddOrEdit=Add&FirstName=\(firstName!)&Surname=\(surname!)&DateOfBirth=\(dateOfBirth)&Mother=\(mother! ?? "")&Father=\(father! ?? "")&Guardian=\(guardian! ?? "")&KeyPerson=\(keyPerson!)&StudentPicture=\(studentPicture)&Student_ID=\(self.StudentID)"
                print(postString)
                request.httpBody = postString.data(using: .utf8)
                
                utilities.postRequest(postString: postString, request: request, completion: { success, data in
                    DispatchQueue.main.async{
                    self.upload(image: self.imgStudent.image!, studentFirstName: firstName!, studentSurname: surname!)
                    }
                })

            })
        }
    }
    
    func editStudent(){
 

                let firstName = self.txtFirstName.text
                let surname = self.txtSurname.text
                let dateOfBirth = self.datePicker.date
                let mother = self.txtMother.text
                let father = self.txtFather.text
                let guardian = self.txtGuardian.text
                print(self.StudentID)
                let keyPerson = self.txtKeyPerson.text
                
                var studentPicture = "https://shod-verses.000webhostapp.com/students/\((self.StudentID))/DisplayPictures/\((firstName!) + (surname!)).jpg"
                
                var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ManagerSidePHPFiles/AddOrEditStudent.php")!)
                request.httpMethod = "POST"
                let postString = "AddOrEdit=Edit&FirstName=\(firstName!)&Surname=\(surname!)&DateOfBirth=\(dateOfBirth)&Mother=\(mother! ?? "")&Father=\(father! ?? "")&Guardian=\(guardian! ?? "")&KeyPerson=\(keyPerson!)&StudentPicture=\(studentPicture)&Student_ID=\(self.StudentID)"
                print(postString)
                request.httpBody = postString.data(using: .utf8)
                
                utilities.postRequest(postString: postString, request: request, completion: { success, data in
                    DispatchQueue.main.async {
                    self.upload(image: self.imgStudent.image!, studentFirstName: firstName!, studentSurname: surname!)
                    }
                })
                
    
        
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
                         to:"https://shod-verses.000webhostapp.com/ManagerSidePHPFiles/ProfileImageUpload.php")
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
    
    func postRequest(postString: String, request: URLRequest, completion: @escaping (_ success : Bool,_ data: Data) -> ()){
        var success = true
        
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
            self.responseArr = (responseString.split(separator: ";") as NSArray) as! [String]
            print("responseString <br /> = \(responseString)")
            
            DispatchQueue.main.async{
                completion(success, data)
            }
        }
        task.resume()
        print(success)
    }
    
    
}


