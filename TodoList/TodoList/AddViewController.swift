//
//  AddViewController.swift
//  TodoList
//
//  Created by gaofeng on 2018/11/26.
//  Copyright © 2018年 com.gaofeng. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    var currentImage:Int = 1
    var content:String = ""

    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var todoContent: UITextField!
    @IBOutlet weak var dataPicker: UIDatePicker!
    
    @IBAction func doneBtn(_ sender: Any) {
        content = todoContent.text!
        let date = dataPicker.date
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.settingNotification(date: date, body: content)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        image1.isUserInteractionEnabled = true
        image2.isUserInteractionEnabled = true
        image3.isUserInteractionEnabled = true
        image4.isUserInteractionEnabled = true
        let image1TapRecognition = UITapGestureRecognizer(target: self, action: #selector(image1Tapped));
        let image2TapRecognition = UITapGestureRecognizer(target: self, action: #selector(image2Tapped));
        let image3TapRecognition = UITapGestureRecognizer(target: self, action: #selector(image3Tapped));
        let image4TapRecognition = UITapGestureRecognizer(target: self, action: #selector(image4Tapped));
        
        image1.addGestureRecognizer(image1TapRecognition)
        image2.addGestureRecognizer(image2TapRecognition)
        image3.addGestureRecognizer(image3TapRecognition)
        image4.addGestureRecognizer(image4TapRecognition)
    }
    
    @objc func imageTapped(recognizer: UITapGestureRecognizer) {
        print("Image was tapped")
        let thePoint = recognizer.location(in: view)
        let theView = recognizer.view
        print(thePoint)
        print(theView!)
    }
    
    @objc func image1Tapped(){
        changeImageViewBack(num: currentImage)
        currentImage = 1
        image1.image = UIImage(named: "animal_selected")
    }
    
    @objc func image2Tapped(){
        changeImageViewBack(num: currentImage)
        currentImage = 2
        image2.image = UIImage(named: "finished_selected")
    }
    
    @objc func image3Tapped(){
        changeImageViewBack(num: currentImage)
        currentImage = 3
        image3.image = UIImage(named: "statics_selected")
    }
    
    @objc func image4Tapped(){
        changeImageViewBack(num: currentImage)
        currentImage = 4
        image4.image = UIImage(named: "todo_selected")
    }
    
    func changeImageViewBack(num: Int){
        switch num {
        case 1:
            image1.image = UIImage(named: "animal")
        case 2:
            image2.image = UIImage(named: "finished")
        case 3:
            image3.image = UIImage(named: "statics")
        case 4:
            image4.image = UIImage(named: "todo")
        default:
            return
        }
    }

}
