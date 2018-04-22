//
//  ViewController.swift
//  Make24
//
//  Created by Yingran Huang on 4/10/18.
//  Copyright © 2018 CMPE277. All rights reserved.
//

import UIKit

class ViewController: UIViewController{

    @IBOutlet weak var leadingConstrain: NSLayoutConstraint!
    @IBOutlet weak var numbtn1: UIButton!
    @IBOutlet weak var numbtn2: UIButton!
    @IBOutlet weak var numbtn3: UIButton!
    @IBOutlet weak var numbtn4: UIButton!
    
    var menuShowing = false
    var solution : String?
    var skip = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        numbtn1.setTitle(num1, for: .normal)
        numbtn2.setTitle(num2, for: .normal)
        numbtn3.setTitle(num3, for: .normal)
        numbtn4.setTitle(num4, for: .normal)
    }

    @IBAction func OpenMenu(_ sender: UIBarButtonItem) {
        if (menuShowing) {
            leadingConstrain.constant = -200
        } else {
            leadingConstrain.constant = 0
            
            UIView.animate(withDuration: 0.3,  animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuShowing = !menuShowing
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Showme(_ sender: UIButton) {
        if (solution != nil) {
            createAlert(title: "Show Me", message: solution)
        } else {
            createAlert(title: "Show Me", message: "No solution for these numbers")
            skip += 1
        }
    }
    
    func createAlert (title:String, message:String!)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        //CREATING ON BUTTON
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print ("OK")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }


}

