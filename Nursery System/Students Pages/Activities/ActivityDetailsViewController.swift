//
//  ActivityDetailsViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 19/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import Alamofire

class ActivityDetailsViewController: UIViewController, UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate, URLSessionTaskDelegate, URLSessionDelegate, URLSessionDataDelegate, UIPopoverPresentationControllerDelegate  {

    var selectedActivity : Activity!
    var selectedStudent : Student!
    var defaultValues = UserDefaults.standard
    
    @IBOutlet var progressIndicatorUpload: UIProgressView!
    @IBOutlet var btnDeleteActivityOutlet: UIButton!
    @IBOutlet var lblStudentName: UILabel!
    @IBOutlet var btnBookmarkOutlet: UIButton!
    @IBOutlet var btnCancelChangesOutlet: UIButton!
    @IBOutlet var btnEditActivityOutlet: UIButton!
    @IBOutlet var btnSaveChangesOutlet: UIButton!
    @IBOutlet var txtActivityObservations: UITextView!
    @IBOutlet var lblActivityTitle: UILabel!
    @IBOutlet var imgActivity: UIImageView!
    @IBOutlet var lblActivityDate: UILabel!
    var dateString = ""
    var bookmark = false
    var A_ID = ""
    var U_ID = ""
    var userRole = ""
    var myDate = Date()
    var ageGroup = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        A_ID = (selectedActivity.A_ID)!
        U_ID = defaultValues.string(forKey: "UserU_ID")!
        userRole = defaultValues.string(forKey: "UserRole")!
        print("yo check this shit out \(userRole)")

        
        lblStudentName.text = "\(selectedStudent.FirstName!) \(selectedStudent.Surname!)"
        print(selectedStudent.FirstName)
        lblActivityTitle.text = selectedActivity.Activity
        txtActivityObservations.text = selectedActivity.Observation

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imgActivity.isUserInteractionEnabled = true
        imgActivity.addGestureRecognizer(tapGestureRecognizer)
        
        let formateDate = utilities.formatDateToString(dateString: selectedActivity.Date!)
        print("heres the returned date \(formateDate)")
        lblActivityDate.text = formateDate


        
        let URL_IMAGE = URL(string: (selectedActivity.A_ID)!)
        print(URL_IMAGE!)
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
                        print("image", image)
                        print(URL_IMAGE!)
                        //display the image
                        DispatchQueue.main.async{
                        self.imgActivity.image = image
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
    }

    @IBAction func btnBookmark(_ sender: Any) {
        if(bookmark == true){
            btnBookmarkOutlet.setImage(UIImage(named: "unchecked bookmark"), for: .normal)
            bookmark = false
        } else {
            btnBookmarkOutlet.setImage(UIImage(named: "checked bookmark"), for: .normal)
            bookmark = true
        }
        updateBookmark()
        
    }
    
    

    
    @IBAction func btnCancelChanges(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm Cancel Changes - This will revert all data", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            self.viewDidLoad()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    
    }
    
    @IBAction func btnSaveChanges(_ sender: Any) {
        
        if(txtActivityObservations.text.isEmpty == false){
        
        let alert = UIAlertController(title: "Confirm Save Changes - This will overwrite all data", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            
        
            let observation = self.txtActivityObservations.text
            
            var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/EditActivity.php")!)
            
            request.httpMethod = "POST"
            
            let postString = ("activityID=\(self.A_ID)&Observation=\(observation!)")
            
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
                
            }
            task.resume()
            self.progressIndicatorUpload.isHidden = false
            self.upload(image: self.imgActivity.image!)
            }))
    
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Error", message: "Text box can not be empty", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        progressIndicatorUpload.isHidden = true
        progressIndicatorUpload.setProgress(0, animated: true)

        if(userRole == "Parent"){
            btnBookmarkOutlet.isHidden = false
            btnDeleteActivityOutlet.isHidden = true
            btnCancelChangesOutlet.isHidden = true
            btnSaveChangesOutlet.isHidden = true
            
            checkBookmarked { success in
                if(self.bookmark == true){
                    self.btnBookmarkOutlet.setImage(UIImage(named: "checked bookmark"), for: .normal)
                } else {
                    self.btnBookmarkOutlet.setImage(UIImage(named: "unchecked bookmark"), for: .normal)
                }
            }
        } else {
        btnDeleteActivityOutlet.isEnabled = true
        imgActivity.isUserInteractionEnabled = true
        btnSaveChangesOutlet.isEnabled = true
        btnCancelChangesOutlet.isEnabled = false
        btnDeleteActivityOutlet.isHidden = false
        btnCancelChangesOutlet.isHidden = false
        btnBookmarkOutlet.isHidden = true
            
        }
    }

    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        _ = tapGestureRecognizer.view as! UIImageView
        print("image tapped")
        let image = UIImagePickerController()  //handles stuff that lets user interact with image
        image.delegate = self
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            image.sourceType = UIImagePickerControllerSourceType.camera
            image.allowsEditing = false
            self.present(image, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Choose from Photo Library", style: .default, handler: { _ in
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary  //pick image from ipad camera roll
            image.allowsEditing = true //hmm
            self.present(image, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{ //check if using image possible
            imgActivity.image = image
        } else {
            print("error using image")//error message
        }
        self.dismiss(animated: true, completion: nil)
        popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
        
    }

    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        txtActivityObservations.isEditable = true
        imgActivity.isUserInteractionEnabled = true
        btnSaveChangesOutlet.isEnabled = true
        btnCancelChangesOutlet.isEnabled = true
        btnEditActivityOutlet.isEnabled = false
    }
    
    func upload(image: UIImage){
        guard let imageData = UIImageJPEGRepresentation(imgActivity.image!, 0.5) else {
            print("could not get jpeg of image")
            return
        }
        
        let activityID = self.selectedActivity.A_ID
        let parameters = ["studentID": "\(selectedStudent.S_ID!)"]
        print(parameters)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "file",fileName: "\((activityID)! + ".jpg")", mimeType: "image/jpg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },
                         to:"https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/ImageUpload.php")
        { (result) in
            switch result {
            case .success(let upload, _, _):
                
                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                    self.progressIndicatorUpload.setProgress(Float(progress.fractionCompleted), animated: true)
                    if(progress.fractionCompleted == 1.0){
                        let alertChangesSuccess = UIAlertController(title: "Successfully edited activity", message: nil, preferredStyle: .actionSheet)
                        
                        alertChangesSuccess.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        
                        if let popoverController = alertChangesSuccess.popoverPresentationController {
                            popoverController.sourceView = self.view
                            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
                            popoverController.permittedArrowDirections = []
                        }
                        
                        self.present(alertChangesSuccess, animated: true, completion: nil)
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
    
    @IBAction func btnDeleteActivity(_ sender: Any) {
        
        
        if(defaultValues.string(forKey: "UserRole") != "Manager"){
       
            let deleteDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())
            print("curr date is \(deleteDate)")
        
            if(myDate < deleteDate!){
                
                print("require manager to delete")
                let alertController = UIAlertController(title: "Error", message: "24HR Delete Period Passed - Request Manager to delete activity", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
                
            }else {
                
                print("delete action")
                self.deleteAlert()
            }
        } else { //if user is manager then dont check for date, just ask for confirmation
           
           self.deleteAlert()
        }
    }
    
    
    func postRequest(postString: String, request: URLRequest, completion: @escaping (_ success : Bool) -> ()){  //extends postrequest but dk how to do that using utilities
        print(postString, request)
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
                
                var responseString = String(data: data, encoding: .utf8)!
                print("responseString = \(responseString)")
                if(responseString == "true"){
                    self.bookmark = true
                } else {
                    self.bookmark = false
                }
                DispatchQueue.main.async{
                    completion(success)
                }
            }
            task.resume()
        print("no here")
        }
    
    func deleteAlert(){
        let alert = UIAlertController(title: "Confirm Delete Activity - This action can NOT be undone.", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            //delete activity
            self.deleteActivity()
            
            let alertDeleteSuccess = UIAlertController(title: "Successfully deleted activity", message: nil, preferredStyle: .actionSheet)
            
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
    
    func updateBookmark(){
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ParentSidePHPFiles/Bookmarks.php")!)
        request.httpMethod = "POST"
        let postString = ("A_ID=\(A_ID)&U_ID=\(U_ID)&Bookmark=\(bookmark)")
        
        request.httpBody = postString.data(using: .utf8)

            postRequest(postString: postString, request: request, completion: { success in
            })
    }
    
    
    func checkBookmarked(completion: @escaping (_ success : Bool) -> ()){
    
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ParentSidePHPFiles/CheckBookmarked.php")!)
        request.httpMethod = "POST"
        
        let postString = ("A_ID=\(self.A_ID)&U_ID=\(self.U_ID)")
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        
        postRequest(postString: postString, request: request, completion: { success in
            completion(success)
        })
        
    }
    
    func deleteActivity(){
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/DeleteActivity.php")!)
        request.httpMethod = "POST"
        let postString = ("A_ID=\(A_ID)")
        
        request.httpBody = postString.data(using: .utf8)
        
        postRequest(postString: postString, request: request, completion: { success in
        })
    }

}
