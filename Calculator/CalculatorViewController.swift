//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by macbookpro on 3/22/17.
//  Copyright © 2017 David Kim. All rights reserved.
//

/* NOTES:
 
 ViewController.swift is the 'Controller' portion of the MVC.
 Main.storyboard is the 'View' portion of MVC, or the graphical representation of our calculator.
 
 The Controller talks to the View using an Outlet/Target Action.
 When the View wants to synchronize with the Controller,
 The View DOES NOT own the data; rather, the View asks for it from the Controller.  In other words, the Controller is usually the data source.
 The Controller interprets/formats the Model data for the View.
 The Model has a 'radio station' (Notification and KVO) that broadcasts changes to its data, and the Controller can 'tune in' and make changes accordingly.
 
 
 
 
 */

// this is kind of like the #include
// this imports a MODULE
// the UIKit module has all the user interface things: buttons, text fields, etc.
import UIKit

// all MVC Controllers must inherit from UIViewController, either directly or indirectly
class CalculatorViewController: UIViewController {
    
    @IBOutlet private weak var display: UILabel!  // this is a property on our controller; an instance variable
    // UILabel! is the type
    // optionals are ALWAYS initialized to 'nil'
    // also, if you change UILabel? to UILabel!, Swift will automatically unwrap
    // basically, if you put the ! where you declare it, it says that anyone can use this thing and it'll implicitly unwrap it (this is called an implicitly unwrapped optional)
    
    private var userIsInTheMiddleOfTyping = false
    private var isDecimalDigitTouched = false
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!  // digit is the button that's pressed by the user
        if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text
            let casesToCheck = (textCurrentlyInDisplay!, digit, isDecimalDigitTouched)
            switch casesToCheck {
            case ("0", _, _):
                if digit != "0" {
                    if digit == "." && isDecimalDigitTouched == false {
                        display.text = textCurrentlyInDisplay! + digit
                        isDecimalDigitTouched = true
                    } else {
                        display.text = digit
                    }
                }
            case (_, ".", false):
                display.text = textCurrentlyInDisplay! + digit
                isDecimalDigitTouched = true
            case (_, ".", true):
                // error message: decimal digit already touched
                break
            default:  // case: digit != "."
                display.text = textCurrentlyInDisplay! + digit
            }
        } else {
            switch digit {
            case ".":
                display!.text = "0" + digit
                isDecimalDigitTouched = true
            default:
                display!.text = digit
            }
        }
        userIsInTheMiddleOfTyping = true
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)  // newValue is a special default value
        }
    }
    
    private var brain = CalculatorBrain()
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            // using the Model, this is the place where calculations happen
            brain.performOperation(mathematicalSymbol)
        }
        isDecimalDigitTouched = false
        displayValue = brain.result
    }
}

