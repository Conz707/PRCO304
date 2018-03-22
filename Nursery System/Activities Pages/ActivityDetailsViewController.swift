//
//  ActivityDetailsViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 19/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import Alamofire

class ActivityDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, URLSessionTaskDelegate, URLSessionDelegate, URLSessionDataDelegate {

    var selectedActivity : ActivitiesModel?
    
    @IBOutlet var activityObservations: UITextView!
    @IBOutlet var activityTitle: UILabel!
    
    @IBOutlet var imgOne: UIImageView!
    
    
    //TEST TEST TEST - This needs to be moved to Create Activity, and upload to the database so must add URLSessions functionality.
    @IBAction func btnUploadImgOne(_ sender: Any) {
        let image = UIImagePickerController()  //handles stuff that lets user interact with image
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.photoLibrary  //pick image from ipad photo library
        image.allowsEditing = false //hmm
        
        self.present(image, animated: true)
        {
            //after it is complete

        }
    }
    
    func upload(image: UIImage){
        guard let imageData = UIImageJPEGRepresentation(imgOne.image!, 0.5) else {
            print("could not get jpeg of image")
            return
        }
        
        let parameters = ["name": "Connor"]
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageData, withName: "fileset",fileName: "file.jpg", mimeType: "image/jpg")
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
        
        let parameters = ["HostName" : "files.000webhost.com"]
        Alamofire.upload(
            multipartFormData: { multipartFormData in
                multipartFormData.append(
                    imageData,
                    withName: "imagefile",
                    fileName: "image.jpg",
                    mimeType: "image/jpeg")
                for (key, value) in parameters {
                    multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                }
        },
            to: "https://shod-verses.000webhostapp.com/ImageUpload.php",
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.validate()
                    upload.responseString { response in
                        guard response.result.isSuccess else {
                            print("Error while uploading file: \(response.result.error)")
                            return
                        }
                        
                        guard let responseString = response.result.value as? [String: Any],
                        let uploadedFiles = responseString["uploaded"] as? [[String: Any]],
                        let firstFile = uploadedFiles.first,
                            let firstFileID = firstFile["id"] as? String else {
                                print("Invalid information received from service")
                                return
                        }
                        print("content uploaded with id: \(firstFileID)")
                    }
                case .failure(let encodingError):
                    print(encodingError)
                }
        })
    }
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{ //check if using image possible
        imgOne.image = image
            upload(image: imgOne.image!)
        } else {
            print("error using image")//error message
        }
        self.dismiss(animated: true, completion: nil)
        
        
        
        
        
    }
    

        
        
        //  let imageData = UIImageJPEGRepresentation(imgOne.image!, 1)
       // if(imageData == nil) { return }
        
   //     let param = [
    //        "userId" : "1"
   //     ]
        
    //    let uploadScriptUrl = NSURL(string:"https://shod-verses.000webhostapp.com/ImageUpload.php")
      //  var request = NSMutableURLRequest(url: uploadScriptUrl! as URL)
     //   request.httpMethod = "POST"
        
      //  let boundary = generateBoundaryString()
        
     //   request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
    //    request.httpBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData, boundary: boundary)
        
  //  }
/*
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createBodyWithParamters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        var body = Data();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.append("--\(boundary)\r\n")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.append("\(value)\r\n")
            }
        }
        
        let filename = "testUpload"
        let mimetype = "image/jpg"
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.append("\r\n")
        
        body.append("--\(boundary)\r\n")
        return body
        
        
    }
    */
//END TEST TEST TEST
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
activityTitle.text = selectedActivity?.activity
activityObservations.text = selectedActivity?.observation
        
        // Do any additional setup after loading the view.
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

}
