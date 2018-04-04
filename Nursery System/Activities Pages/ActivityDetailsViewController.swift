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

    var selectedActivity : ActivitiesModel?
    var selectedStudent : StudentsModel = StudentsModel()   //WHY???
    
    @IBOutlet var btnCancelChangesOutlet: UIButton!
    @IBOutlet var btnEditActivityOutlet: UIButton!
    @IBOutlet var btnSaveChangesOutlet: UIButton!
    @IBOutlet var txtActivityObservations: UITextView!
    @IBOutlet var lblActivityTitle: UILabel!
    @IBOutlet var imgActivity: UIImageView!
    @IBOutlet var lblActivityDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblActivityTitle.text = selectedActivity?.activity
        txtActivityObservations.text = selectedActivity?.observation
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        
        imgActivity.isUserInteractionEnabled = true
        imgActivity.addGestureRecognizer(tapGestureRecognizer)
        
        //Convert String to Date for formatting
        let dateString = selectedActivity?.activityDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let myDate = dateFormatter.date(from: dateString!)!
        print("original date is \(dateString!)")
        
        //Convert date back to String
        dateFormatter.dateFormat = "MMMM dd, YYYY"
        let newDateString = dateFormatter.string(from: myDate)
        print("new date string is \(newDateString)")
        lblActivityDate.text = "\(newDateString)"
        
        let URL_IMAGE = URL(string: (selectedActivity?.activityPicture)!)
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

    @IBAction func btnEditActivity(_ sender: Any) {
        txtActivityObservations.isEditable = true
        imgActivity.isUserInteractionEnabled = true
        btnEditActivityOutlet.isEnabled = false
        btnSaveChangesOutlet.isEnabled = true
        btnCancelChangesOutlet.isEnabled = true
    }
    
    @IBAction func btnCancelChanges(_ sender: Any) {
        let alert = UIAlertController(title: "Confirm Cancel Changes - This will revert all data", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            self.viewDidLoad()
            self.btnEditActivityOutlet.isEnabled = true
            self.btnSaveChangesOutlet.isEnabled = false
            self.btnCancelChangesOutlet.isEnabled = false
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
        
        let alert = UIAlertController(title: "Confirm Save Changes - This will overwrite all data", message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .default, handler: { _ in
            
            self.btnEditActivityOutlet.isEnabled = true
            self.btnSaveChangesOutlet.isEnabled = false
            self.btnCancelChangesOutlet.isEnabled = false
            self.txtActivityObservations.isEditable = false
            self.imgActivity.isUserInteractionEnabled = false
            
            let activity = self.selectedActivity?.activity
            let A_ID = self.selectedActivity?.activityID
            let observation = self.txtActivityObservations.text
            
            var request = URLRequest(url: URL(string: "https://shod-verses.000webhostapp.com/EditActivity.php")!)
            
            request.httpMethod = "POST"
            
            let postString = ("activityID=\(A_ID!)&Observation=\(observation!)")
            
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
            self.upload(image: self.imgActivity.image!, activity2: activity!)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        txtActivityObservations.isEditable = false
        imgActivity.isUserInteractionEnabled = false
        btnSaveChangesOutlet.isEnabled = false
        btnCancelChangesOutlet.isEnabled = false
        btnEditActivityOutlet.isEnabled = true
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
