//
//  assignnumViewController.swift
//  Make24
//
//  Created by Yingran Huang on 4/19/18.
//  Copyright © 2018 CMPE277. All rights reserved.
//

import UIKit

var num1: String!
var num2: String!
var num3: String!
var num4: String!
var assign = true

class assignnumViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
    @IBOutlet weak var numpicker1: UIPickerView!
    @IBOutlet weak var numpicker2: UIPickerView!
    @IBOutlet weak var numpicker3: UIPickerView!
    @IBOutlet weak var numpicker4: UIPickerView!
    
    let nums = ["1","2","3","4","5","6","7","8","9"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nums.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return nums[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        num1 = nums[numpicker1.selectedRow(inComponent: component)]
        num2 = nums[numpicker2.selectedRow(inComponent: component)]
        num3 = nums[numpicker3.selectedRow(inComponent: component)]
        num4 = nums[numpicker4.selectedRow(inComponent: component)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func assignNum(_ sender: UIButton) {
        print ("assigne numbers!")
        assign = false
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
