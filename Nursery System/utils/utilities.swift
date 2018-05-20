//
//  utils.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 27/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit
import Alamofire

class utilities{
    
    var users = [User]()
    var students = [Student]()

    static func postRequest(postString: String, request: URLRequest, completion: @escaping(_ success : Bool, _ data: Data, _ responseString: String) -> ()){    //post function commonly used
        print("using utilities")
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
            
            let responseString = String(data: data, encoding: .utf8)!
            print("responseString = \(responseString)")
            completion(success, data, responseString)
        }
        task.resume()
    }
    
    
    static func formatDateToString(dateString: String) -> String{       //format date to string for display purposes
        
        var myDate = Date()
        
        //Convert String to Date for formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        myDate = dateFormatter.date(from: dateString)!
        print("original date is \(dateString)")
        
        //Convert date back to String
        dateFormatter.dateFormat = "MMMM dd, YYYY"
        let newDateString = dateFormatter.string(from: myDate)
        print("new date string is \(newDateString)")
        
        return newDateString
    }
    
    static func formatStringToDate(dateString: String) -> Date{         //format string to date for datepickers
        
        var newDate = Date()
        print(dateString)

        //Convert String to Date for formatting
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        newDate = dateFormatter.date(from: dateString)!
        print("original date is \(dateString)")
        
        return newDate
        
    }
    
    static func getImages(URL_IMAGE: URL, completion: @escaping (_ success : Bool, _ image : UIImage) -> ()){   //gets images from url
        
        let imageCache = NSCache<AnyObject, AnyObject>()
        var success = true
        
        
        let session = URLSession(configuration: .default)
        
        //create a dataTask
        let getImageFromUrl = session.dataTask(with: URL_IMAGE) { data, response, error in
            
            //if error
            if let e = error {
                //display message
                print("Error occurred: \(e)")
            } else {
                if (response as? HTTPURLResponse) != nil {
                    
                    //check response contains image
                    if let imageData = data {
                        
                        //get image
                        var image = UIImage(data: imageData)
                        
                        if let cachedImage = imageCache.object(forKey: URL_IMAGE as AnyObject) as? UIImage {
                            image = cachedImage
                            return
                        }
                        
                        //complete - return image
                        completion(success, image!)
                        
                    } else {
                        print("image corrupted")
                        success = false
                    }
                } else {
                    print("No server response")
                    success = false
                }
            }
            
            
        }
        getImageFromUrl.resume()
    

    }
    
    static func checkInputValid(type:String, input: String) -> Bool {      //test text against regex
        var textRegEx = ""
        
        switch(type){
        case "Email":
            textRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
            
        case "Password":
            textRegEx = "[A-Z0-9a-z]{6,18}" // password entry must be 6 - 18 digits - make sure alert represents this
            
        case "Text":
            textRegEx = "[a-zA-Z0-9,.!?@'()£$%&+_?|:}]{1,400}"
            
        case "Name":
            textRegEx = "[A-Z0-9a-z]{1,16}"
            
        case "TelNum":
            textRegEx = "[0]+[0-9]{1,10}"   //ensure telnum starts with 0 and 11 digits total
            
        default:
            break
            
        }
        
        let testIfValid = NSPredicate(format: "SELF MATCHES %@", textRegEx)
        return testIfValid.evaluate(with: input)
        
    }
    
    static func normalAlertBox(alertTitle: String,messageString: String) -> UIAlertController{   //call alert box with custom title and message
        
        let alertController = UIAlertController(title: alertTitle, message: messageString, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Close Alert", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        
       return alertController
        
    }
    
    static func actionSheetAlertBox(alertTitle: String, _ sender: Any) -> UIAlertController{   //call alert box with actions attached to it
        
        let alertController = UIAlertController(title: alertTitle, message: nil, preferredStyle: .actionSheet)
        
        let alertActionCancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil) //all action sheets have cancel by default
        
        alertController.addAction(alertActionCancel)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = (sender as AnyObject).view
            popoverController.sourceRect = CGRect(x: (sender as AnyObject).view.bounds.midX, y: (sender as AnyObject).view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        return alertController
        
}

    
    @objc static func imageTapped(image: UIImagePickerController, sender: Any) -> UIAlertController{     //function to recognise tapping an image to upload or change photo
        
        let alertImageTapped = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)

        
        //Alert Box Action Sheet Actions
        
        //take photo
        let alertActionTakePhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            image.sourceType = UIImagePickerControllerSourceType.camera
            image.allowsEditing = false
            return (sender as AnyObject).present(image, animated: true, completion: nil)
            
        })
        
        //choose photo from library
        let alertActionChooseFromLibrary = UIAlertAction(title: "Choose from Photo Library", style: .default, handler: { _ in
            image.sourceType = UIImagePickerControllerSourceType.photoLibrary  //pick image from ipad camera roll
            image.allowsEditing = true
            return (sender as AnyObject).present(image, animated: true, completion: nil)
        })
        
        
        //cancel
        let alertActionCancel = UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil)
        
         alertImageTapped.addAction(alertActionTakePhoto)
         alertImageTapped.addAction(alertActionChooseFromLibrary)
         alertImageTapped.addAction(alertActionCancel)
       
        
        if let popoverController = alertImageTapped.popoverPresentationController {
            popoverController.sourceView = (sender as AnyObject).view
            popoverController.sourceRect = CGRect(x: (sender as AnyObject).view.bounds.midX, y: (sender as AnyObject).view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        
        return alertImageTapped
    }
    
}

