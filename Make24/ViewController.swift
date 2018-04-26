//
//  ViewController.swift
//  Make24
//
//  Created by Yingran Huang on 4/10/18.
//  Copyright © 2018 CMPE277. All rights reserved.
//

import UIKit
import Foundation
import NotificationBannerSwift

public struct Stack<T> {
    fileprivate var array = [T]()
    
    public var isEmpty: Bool {
        return array.isEmpty
    }
    
    public var count: Int {
        return array.count
    }
    
    public mutating func push(_ element: T) {
        array.append(element)
    }
    
    public mutating func pop() -> T? {
        return array.popLast()
    }
    
    public var top: T? {
        return array.last
    }
}

class ViewController: UIViewController{

    @IBOutlet weak var leadingConstrain: NSLayoutConstraint!
    @IBOutlet weak var numbtn1: UIButton!
    @IBOutlet weak var numbtn2: UIButton!
    @IBOutlet weak var numbtn3: UIButton!
    @IBOutlet weak var numbtn4: UIButton!
    @IBOutlet weak var equationTV: UITextView!
    @IBOutlet weak var plusbtn: UIButton!
    @IBOutlet weak var minusbtn: UIButton!
    @IBOutlet weak var multibtn: UIButton!
    @IBOutlet weak var dividebtn: UIButton!
    @IBOutlet weak var leftbtn: UIButton!
    @IBOutlet weak var rightbtn: UIButton!
    @IBOutlet weak var delbtn: UIButton!
    @IBOutlet weak var donebtn: UIButton!
    @IBOutlet weak var timeTF: UITextField!
    @IBOutlet weak var attemptTF: UITextField!
    @IBOutlet weak var successTF: UITextField!
    @IBOutlet weak var skipTF: UITextField!
    
    var menuShowing = false
    var solution : String?
    var skip = 0
    var attempt = 1
    var success = 0
    var started = false
    var time = Timer()
    var secound = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        reset(genNum: assign, resetTime: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Showme(_ sender: UIBarButtonItem) {
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
        alert.addAction(UIAlertAction(title: "Next Puzzle", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            print ("OK")
            
            self.reset(genNum: true, resetTime: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func reset (genNum:Bool, resetTime:Bool)
    {
        if resetTime {
            started = false
            startTimer()
        }
        
        equationTV.text = ""
        
        if genNum {
            repeat {
                num1 = String(arc4random_uniform(9) + 1)
                num2 = String(arc4random_uniform(9) + 1)
                num3 = String(arc4random_uniform(9) + 1)
                num4 = String(arc4random_uniform(9) + 1)
                print ("Generated nums: " + num1 + ", " + num2)
                print ("Generated nums: " + num3 + ", " + num4)
                solution = getSolution(n1: num1, n2: num2, n3: num3, n4: num4)
            } while solution == nil
        }
        
        numbtn1.setTitle(num1, for: .normal)
        numbtn2.setTitle(num2, for: .normal)
        numbtn3.setTitle(num3, for: .normal)
        numbtn4.setTitle(num4, for: .normal)
        
        numbtn1.isEnabled = true
        numbtn2.isEnabled = true
        numbtn3.isEnabled = true
        numbtn4.isEnabled = true
        donebtn.isEnabled = false
        
        successTF.text = String(success)
        skipTF.text = String(skip)
        attemptTF.text = String(attempt)
    }
    
    func startTimer() {
        time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounter() {
        secound += 1
        let min = Int(secound/60)
        let sec = secound - min * 60
        if sec < 10 {
            timeTF.text = "\(min):0\(sec)"
        }else{
            timeTF.text = "\(min):\(sec)"
        }
    }
    
    func getSolution(n1 : String, n2 : String, n3 : String, n4 : String) -> String? {
        var n = [n1, n2, n3, n4]
        var o = ["+", "-", "*", "/"]
        for w in 0...3 {
            for x in 0...3 {
                if x == w {
                    continue
                }
                for y in 0...3 {
                    if y == x || y == w {
                        continue
                    }
                    for z in 0...3 {
                        if z == w || z == x || z == y {
                            continue
                        }
                        for i in 0...3 {
                            for j in 0...3 {
                                for k in 0...3 {
                                    let result = evalSolution(n1: Int(n[w]), n2: Int(n[x]), n3: Int(n[y]), n4: Int(n[z]), o1: Character(o[i]), o2: Character(o[j]), o3: Character(o[k]));
                                    if result != nil {
                                        return result
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return nil
    }
    
    func evalSolution(n1 : Int!, n2 : Int!, n3 : Int!, n4 : Int!, o1 : Character, o2 : Character, o3 : Character) -> String? {
        var result : String!
        if bingo(res: eval(a: eval(a: eval(a: Double(n1), x: o1, b: Double(n2)), x: o2, b: Double(n3)), x: o3, b: Double(n4))) {
            result = "((" + String(n1) + String(o1) + String(n2) + ")"
            result = result + String(o2) + String(n3) + ")"
            result = result + String(o3) + String(n4)
            return result
        }
        if bingo(res: eval(a: eval(a: Double(n1), x: o1, b: eval(a: Double(n2), x: o2, b: Double(n3))), x: o3, b: Double(n4))) {
            result = "(" + String(n1) + String(o1)
            result = result + "(" + String(n2)
            result = result + String(o2) + String(n3) + "))"
            result = result + String(o3) + String(n4)
            return result
        }
        if (bingo(res: eval(a: Double(n1), x: o1, b: eval(a: eval(a: Double(n2), x: o2, b: Double(n3)), x: o3, b: Double(n4))))) {
            result = "" + String(n1) + String(o1)
            result = result + "((" + String(n2)
            result = result + String(o2) + String(n3) + ")"
            result = result + String(o3) + String(n4) + ")"
            return result
        }
        if (bingo(res: eval(a: Double(n1), x: o1, b: eval(a: Double(n2), x: o2, b: eval(a: Double(n3), x: o3, b: Double(n4)))))) {
            result = "" + String(n1) + String(o1) + "(" + String(n2) + String(o2)
            result = result + "(" + String(n3)
            result = result + String(o3) + String(n4) + ")" + ")"
            return result
        }
        if (bingo(res: eval(a: eval(a: Double(n1), x: o1, b: Double(n2)), x: o2, b: eval(a: Double(n3), x: o3, b: Double(n4))))) {
            result = "((" + String(n1) + String(o1) + String(n2) + ")" + String(o2)
            result = result + "(" + String(n3) + String(o3) + String(n4) + "))"
            return result
        }
        return nil
    }
    
    func bingo(res : Double) -> Bool {
        return abs(res - 24) < 0.0000001
    }
    
    func eval(a : Double, x : Character, b : Double) -> Double {
        switch x {
            case "+":
                return a + b
            case "-":
                return a - b
            case "*":
                return a * b
            default:
                return a / b
        }
    }

    @IBAction func num1Pressed(_ sender: UIButton) {
        numbtn1.isEnabled = false
        print (numbtn1.titleLabel!.text!)
        equationTV.text = equationTV.text! + numbtn1.titleLabel!.text!
    }
    
    @IBAction func num2Pressed(_ sender: UIButton) {
        numbtn2.isEnabled = false
        print (numbtn2.titleLabel!.text!)
        equationTV.text = equationTV.text + numbtn2.titleLabel!.text!
    }
    
    @IBAction func num3Pressed(_ sender: UIButton) {
        numbtn3.isEnabled = false
        print (numbtn3.titleLabel!.text!)
        equationTV.text = equationTV.text + numbtn3.titleLabel!.text!
    }
    
    @IBAction func num4Pressed(_ sender: UIButton) {
        numbtn4.isEnabled = false
        print (numbtn4.titleLabel!.text!)
        equationTV.text = equationTV.text + numbtn4.titleLabel!.text!
    }
    
    @IBAction func plusPressed(_ sender: UIButton) {
        donebtn.isEnabled = true
        equationTV.text = equationTV.text + plusbtn.titleLabel!.text!
    }
    
    @IBAction func minusPressed(_ sender: UIButton) {
        donebtn.isEnabled = true
        equationTV.text = equationTV.text + minusbtn.titleLabel!.text!
    }
    
    @IBAction func mulitPressed(_ sender: UIButton) {
        donebtn.isEnabled = true
        equationTV.text = equationTV.text + multibtn.titleLabel!.text!
    }
    
    @IBAction func dividePressed(_ sender: UIButton) {
        donebtn.isEnabled = true
        equationTV.text = equationTV.text + dividebtn.titleLabel!.text!
    }
    
    @IBAction func leftPressed(_ sender: UIButton) {
        donebtn.isEnabled = true
        equationTV.text = equationTV.text + leftbtn.titleLabel!.text!
    }

    @IBAction func rightPressed(_ sender: UIButton) {
        donebtn.isEnabled = true
        equationTV.text = equationTV.text + rightbtn.titleLabel!.text!
    }
    
    @IBAction func delPressed(_ sender: UIButton) {
        if equationTV.text.last != nil {
            donebtn.isEnabled = true
            let char = equationTV.text.last!
            if char >= "0" && char <= "9" {
                if numbtn1.isEnabled == false && numbtn1.titleLabel?.text == String(char) {
                    numbtn1.isEnabled = true
                } else if numbtn2.isEnabled == false && numbtn2.titleLabel?.text == String(char) {
                    numbtn2.isEnabled = true
                } else if numbtn3.isEnabled == false && numbtn3.titleLabel?.text == String(char) {
                    numbtn3.isEnabled = true
                } else {
                    numbtn4.isEnabled = true
                }
            }
            equationTV.text = String(equationTV.text.prefix(equationTV.text.count - 1))
        }
    }
    
    @IBAction func donePressed(_ sender: UIButton) {
        donebtn.isEnabled = false
        attempt += 1
        attemptTF.text = String(attempt)
        let postExpression = convertToPostFix(input: equationTV.text)
        let result = calculate(input: postExpression)
        if bingo(res: result) {
            //createAlert(title: "Succeed!", message: "Bingo! \(equationTV.text) = 24", action: "Next Puzzle")
            createAlert(title: "Succeed!", message: "Bingo! \(equationTV.text) = 24")
            success += 1
            successTF.text = String(success)
            attempt = 1
            attemptTF.text = String(attempt)
        }else {
            let banner = NotificationBanner(title: "Incorrect. Please try again!", style: .warning)
            banner.show()
        }
    }
    
    func calculate(input: String) -> Double {
        var stack = Stack<Double>()
        var d1:Double = 0
        var d2:Double = 0
        var d3:Double = 0
        for i in 0..<input.count {
            let ch = Array(input)[i]
            if ch >= "0" && ch <= "9" {
                stack.push(Double(String(ch))!)
            }
            else {
                if stack.isEmpty == false {
                    d2 = stack.pop()!
                }
                if stack.isEmpty == false {
                    d1 = stack.pop()!
                }
                switch ch {
                case "+":
                    d3 = d1 + d2
                case "-":
                    d3 = d1 - d2
                case "*":
                    d3 = d1 * d2
                default:
                    d3 = d1 / d2
                }
                stack.push(d3)
            }
        }
        return stack.pop()!
    }
    
    func convertToPostFix(input: String) -> String {
        var stringBuilder = ""
        var operatorStack = Stack<Character>()
        for i in 0..<input.count {
            let ch = Array(input)[i]
            print("ch: \(ch)")
            if ch >= "0" && ch <= "9" {
                stringBuilder += String(ch)
            }
            //left bracket
            if ch == "(" {
                operatorStack.push(ch)
            }
            //operator
            if isOperator(op: ch) {
                if operatorStack.isEmpty == true {
                    operatorStack.push(ch)
                }
                else {
                    var stackTop = operatorStack.top
                    if priority(ch: ch) > priority(ch: stackTop!) {
                        operatorStack.push(ch)
                    }
                    else {
                        stackTop = operatorStack.pop()
                        stringBuilder += String(stackTop!)
                        operatorStack.push(ch)
                    }
                }
            }
            //right bracket
            if ch == ")" {
                var top = operatorStack.pop()
                while top != "(" {
                    stringBuilder += String(top!)
                    top = operatorStack.pop()
                }
            }
        }
        while operatorStack.isEmpty == false {
            stringBuilder += String(operatorStack.pop()!)
        }
        print(stringBuilder)
        return stringBuilder
    }
    
    func priority(ch: Character) -> Int {
        if ch == "+" || ch == "-" {
            return 1
        }
        if ch == "*" || ch == "/" {
            return 2
        }
        return 0
    }
    
    func isOperator(op: Character) -> Bool {
        return (op == "+") || (op == "-") || (op == "*") || (op == "/")
    }
}

