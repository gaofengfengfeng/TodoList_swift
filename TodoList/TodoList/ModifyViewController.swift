//
//  ModifyViewController.swift
//  TodoList
//
//  Created by gaofeng on 2018/11/27.
//  Copyright © 2018年 com.gaofeng. All rights reserved.
//

import UIKit

class ModifyViewController: UIViewController {

    var itemString:String?
    
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var todoContent: UITextField!
    
    @IBAction func cancelBtn(_ sender: UIButton) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func modifyBtn(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        todoContent.text = itemString
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
