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

    @IBOutlet var lblGoal: UILabel!
    @IBOutlet var lblGoalAchieved: UILabel!
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
    var selectedActivity : Activity!
    var selectedStudent : Student!
    var defaultValues = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        A_ID = (selectedActivity.A_ID)!
        U_ID = defaultValues.string(forKey: "UserU_ID")!
        userRole = defaultValues.string(forKey: "UserRole")!

        checkIfGoalAchieved()       
        getActivityImage()
        
        lblStudentName.text = "\(selectedStudent.FirstName!) \(selectedStudent.Surname!)"
        print(selectedStudent.FirstName)
        lblActivityTitle.text = selectedActivity.Activity
        txtActivityObservations.text = selectedActivity.Observation

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))      //used to recognise tap on image
        
        
        if(defaultValues.string(forKey: "UserRole") != "Parent"){
        imgActivity.isUserInteractionEnabled = true
        txtActivityObservations.isUserInteractionEnabled = true
        txtActivityObservations.isEditable = true
        }
        imgActivity.addGestureRecognizer(tapGestureRecognizer)
        
        let formateDate = utilities.formatDateToString(dateString: selectedActivity.Date!)
        print("heres the returned date \(formateDate)")
        lblActivityDate.text = formateDate

        

    }

    @IBAction func btnBookmark(_ sender: Any) {     //if bookmark is true, pressing button changes to false - function for parents side
        if(bookmark){
            btnBookmarkOutlet.setImage(UIImage(named: "unchecked bookmark"), for: .normal)
            bookmark = false
        } else {
            btnBookmarkOutlet.setImage(UIImage(named: "checked bookmark"), for: .normal)
            bookmark = true
        }
        updateBookmark()
        
    }
    
    
    @IBAction func btnCancelChanges(_ sender: Any) {        //confirm cancel changes then call cancel changes
        
        let utilActionSheet = utilities.actionSheetAlertBox(alertTitle: "Confirm Cancel Changes - This will revert all data", self)
        
        
        let confirmButton = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            self.viewDidLoad()
        })
        
        utilActionSheet.addAction(confirmButton)
        

        self.present(utilActionSheet, animated: true)
        
        
    }
    
    @IBAction func btnSaveChanges(_ sender: Any) {  //confirm changes then call updateactivity
        
        if(txtActivityObservations.text.isEmpty == false){      //as long as activity text isn't empty perform next
            
            let utilActionSheet = utilities.actionSheetAlertBox(alertTitle: "Confirm Save Changes - This will overwrite all data", self)
            let confirmButton = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                self.upload(image: self.imgActivity.image!)
                self.updateActivity()

            })
            utilActionSheet.addAction(confirmButton)
            self.present(utilActionSheet, animated: true)
            

            } else {
        
        self.present(utilities.normalAlertBox(alertTitle: "Error", messageString: "Text box can not be empty"), animated: true)
    
        }
       
    }

func updateActivity(){      //called after update alert confirmed
    
    let observation = self.txtActivityObservations.text!
    let postString = ("activityID=\(self.A_ID)&Observation=\(observation)")
    var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/EditActivity.php")!)
    request.httpMethod = "POST"
    request.httpBody = postString.data(using: .utf8)

    utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
    
            })
//removed upload from here and put in the button
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {     //re-prepare page everytime it opens
        
        progressIndicatorUpload.isHidden = true
        progressIndicatorUpload.setProgress(0, animated: true)

        if(userRole == "Parent"){       //if user parent, hide manager and teacher areas
            btnBookmarkOutlet.isHidden = false
            btnDeleteActivityOutlet.isHidden = true
            btnCancelChangesOutlet.isHidden = true
            btnSaveChangesOutlet.isHidden = true
            checkBookmarked { success in
                DispatchQueue.main.async{
                if(self.bookmark == true){
                    self.btnBookmarkOutlet.setImage(UIImage(named: "checked bookmark"), for: .normal)
                } else {
                    self.btnBookmarkOutlet.setImage(UIImage(named: "unchecked bookmark"), for: .normal)
                    }
                }
            }
        } else {
            btnDeleteActivityOutlet.isEnabled = true
            imgActivity.isUserInteractionEnabled = true
            btnSaveChangesOutlet.isEnabled = true
            btnCancelChangesOutlet.isEnabled = true
            btnDeleteActivityOutlet.isHidden = false
            btnCancelChangesOutlet.isHidden = false
            btnBookmarkOutlet.isHidden = true
        }
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){   //recognize tap and call util function - pass in image and view controller as sender
        _ = tapGestureRecognizer.view as! UIImageView
        let image = UIImagePickerController()
        image.delegate = self
        print("image tapped")
        
        let utilImageTapped = utilities.imageTapped(image: image, sender: self)

        self.present(utilImageTapped, animated: true)
        
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) { //pick an image
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{ //check if using image possible
            imgActivity.image = image
        } else {
            print("error using image")//error message
        }
        self.dismiss(animated: true, completion: nil)
    //    popoverPresentationController?.delegate?.popoverPresentationControllerDidDismissPopover?(popoverPresentationController!)
        
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
                         to:"https://shod-verses.000webhostapp.com/ImageUpload.php")
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

    
    @IBAction func btnDeleteActivity(_ sender: Any) {       //managers should be able to delete all activities if needed, whereas a teacher should only be able to delete an accidental, therefore a time period they can delete is allowed
        
        
        if(defaultValues.string(forKey: "UserRole") != "Manager"){
       
            let deleteDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())       //24hr date
    
            if(myDate < deleteDate!){       //check activity date vs delete date to ensure within time period
                    self.present(utilities.normalAlertBox(alertTitle: "Error", messageString: "24HR Delete Period Passed - Request Manager to delete activity"), animated: true)
            }else {
                
                self.deleteAlert()
            }
        } else { //if user is manager then dont check for date, just ask for confirmation
           self.deleteAlert()
        }
    }
    
    func deleteAlert(){     //alert for delete, if confirmed call the delete function
        
        let utilActionSheet = utilities.actionSheetAlertBox(alertTitle: "Confirm Delete Activity - This action can NOT be undone.", self)
  
        let utilActionSheetConfirmButton = UIAlertAction(title: "Confirm", style: .default, handler: { _ in  //confirm delete on initial action sheet
        
        self.deleteActivity()
        
        let alertDeleteSuccess = utilities.actionSheetAlertBox(alertTitle: "Successfully deleted activity", self) //nested action sheet that after deleting activity, returns to previous view
            let alertDeleteConfirm = UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        })
            alertDeleteSuccess.addAction(alertDeleteConfirm)
        self.present(alertDeleteSuccess, animated: true)
    })
        
        utilActionSheet.addAction(utilActionSheetConfirmButton)
        
        self.present(utilActionSheet, animated: true)
    }
    
    
    
    func updateBookmark(){      //change bookmark boolean T/F and send to database
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ParentSidePHPFiles/Bookmarks.php")!)
        request.httpMethod = "POST"
        let postString = ("A_ID=\(A_ID)&U_ID=\(U_ID)&Bookmark=\(bookmark)")
        
        request.httpBody = postString.data(using: .utf8)

            utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
                if(responseString == "true"){
                    self.bookmark = true
                } else {
                    self.bookmark = false
                }
            })
    }
    
    
    func checkBookmarked(completion: @escaping (_ success : Bool) -> ()){   //check database and set initial bookmark to T/F
    
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/ParentSidePHPFiles/CheckBookmarked.php")!)
        request.httpMethod = "POST"
        
        let postString = ("A_ID=\(self.A_ID)&U_ID=\(self.U_ID)")
        print(postString)
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in
          
            if(responseString == "true"){
                self.bookmark = true
            } else {
                self.bookmark = false
            }
            completion(success)
        })
        
    }
    
    
    
    func deleteActivity(){
        
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/DeleteActivity.php")!)
        request.httpMethod = "POST"
        let postString = ("A_ID=\(A_ID)")
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data,responseString  in
        })
    }
    
    
    
    func checkIfGoalAchieved(){ //check whether a goal has been achieved with the activity and display if it has
        
        let postString = ("A_ID=\(self.A_ID)")
        var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/TeacherSidePHPFiles/CheckIfGoalAchieved.php")!)
        request.httpMethod = "POST"
        request.httpBody = postString.data(using: .utf8)
        
        utilities.postRequest(postString: postString, request: request, completion: { success, data, responseString in

                DispatchQueue.main.async{   //if responseString empty then goal hasn't been achieved on activity, so hide labels
                if(responseString != ""){
                    self.lblGoal.text = responseString
                    self.lblGoalAchieved.isHidden = false
                    self.lblGoal.isHidden = false
                } else {
                    self.lblGoal.isHidden = true
                    self.lblGoalAchieved.isHidden = true
                }
            }
        })
    }
    
    
    
    func getActivityImage(){        //use util function to get image from url and display it
        
        utilities.getImages(URL_IMAGE: URL(string: (selectedActivity.ActivityPicture)!)!, completion: { success, image in
            
            //display the image
            DispatchQueue.main.async{
                self.imgActivity.image = image
            }
        })
    }
    }


