//
//  ParentTeacherMeetingViewController.swift
//  Nursery System
//
//  Created by (s) Connor Smith 1 on 10/04/2018.
//  Copyright © 2018 (s) Connor Smith 1. All rights reserved.
//

import UIKit

class ParentTeacherMeetingViewController: UIViewController {
    

    @IBOutlet var parentsOutletCollection: [UIButton]!
    
    @IBOutlet var txtBox1: UITextField!
    @IBOutlet var dropdown: UITextField!
    @IBOutlet var pickerDropDown: UIPickerView!

    @IBOutlet var btnSelectParentOutlet: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
    }
    

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnSelectParent(_ sender: Any) {
        btnSelectParentOutlet.isHidden = true
        parentsOutletCollection.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                            button.isHidden = !button.isHidden
                            self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func parentTapped(_ sender: Any) {

        guard let title = (sender as AnyObject).currentTitle, let parent = Parents(rawValue: title!) else {
            return
        }
        
        switch parent {
        case .mother:
            print("mother")
        case .father:
            print("father")
        default:
            print("kys")
        }
    }
    
    enum Parents: String {
        case mother = "Mother"
        case father = "Father"
    }
    /*
  
     @IBAction func parentTapped(_ sender: Any) {
     }
     // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
