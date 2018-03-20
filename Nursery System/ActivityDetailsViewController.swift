//
//  ActivityDetailsViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 19/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class ActivityDetailsViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{ //check if using image possible
        imgOne.image = image
        } else {
            print("error using image")//error message
        }
        
        self.dismiss(animated: true, completion: nil)
    }
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
