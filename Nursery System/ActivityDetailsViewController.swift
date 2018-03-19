//
//  ActivityDetailsViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 19/03/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class ActivityDetailsViewController: UIViewController, UIImagePickerControllerDelegate {

    var selectedActivity : ActivitiesModel?
    
    @IBOutlet var activityObservations: UITextView!
    @IBOutlet var activityTitle: UILabel!
    
    @IBOutlet var imgOne: UIImageView!
    @IBAction func btnUploadImgOne(_ sender: Any) {
        let imgOne = UIImagePickerController()
     //   imgOne.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        imgOne.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        imgOne.allowsEditing = false
        
        self.present(imgOne, animated: true)
        {
            //after it is complete
        }
    }
    
    
    
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
