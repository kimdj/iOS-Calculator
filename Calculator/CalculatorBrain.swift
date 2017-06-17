//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by macbookpro on 3/24/17.
//  Copyright © 2017 David Kim. All rights reserved.
//

import Foundation  // NEVER import a UIKit in the Model


/* NOTES:
 
 CalculatorBrain.swift is the 'Model' portion of the MVC.
 
 */

/*
 This is what Optional looks like:
 
 enum Optional<T> {
 case None
 case Some(T)
 }
 */

/*
 // this is a global function
 func multiply(op1: Double, op2: Double) -> Double {
 /*let result = op1 * op2
 return result*/
 return op1 * op2
 
 // this is the inline function version (also called a CLOSURE)
 "×" : Operation.BinaryOperation({ (op1: Double, op2: Double) -> Double in return op1 * op2 }),

 
 // Swift can infer the argument types and the return type
 Operation.BinaryOperation({ (op1, op2) in return op1 * op2 })
 
 // Swift also uses the dollar sign symbol to represent default arguments
 Operation.BinaryOperation({ $0 * $1 })
 }*/

// this is a base class, it doesn't have a superclass
class CalculatorBrain
{
    //private var accumulator: Double = 0.0
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    func setOperand(_ operand: Double) {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    /*  // REPLACED WITH A DICT & ENUM (factored out the mathematical operators)
     func performOperation(symbol: String) {
     switch symbol {
     case "π": accumulator = M_PI
     case "√": accumulator = sqrt(accumulator)
     default: break
     }
     }
     */
    
    private var description: String = "" // contains a description of the sequence of operands and operations that led to the returned value
    private var isPartialResult: Bool = false  // determines whether there is a binary operation pending
    
    // note: these characters are a mixture of special Math Symbols and regular chars
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(Double.pi),
        "e" : Operation.Constant(M_E),
        "±" : Operation.UnaryOperation({ -$0 }),
        "%" : Operation.UnaryOperation({ $0 / 100 }),
        "√" : Operation.UnaryOperation(sqrt),
        "cos" : Operation.UnaryOperation(cos),
        "×" : Operation.BinaryOperation({ $0 * $1 }),  // closures can have default argument symbols: $0, $1, $2, etc.
        "÷" : Operation.BinaryOperation({ $0 / $1 }),  // closures are MAGIC!
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "−" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals,
        "AC" : Operation.Clear
    ]
    
    private enum Operation {
        case Constant(Double)  // Double is the associated value
        case UnaryOperation((Double) -> Double)  // func is the associated value
        case BinaryOperation((Double, Double) -> Double)  // func that takes 2 Doubles and returns a Double is the associated value
        case Equals
        case Clear
        
        // enums are PASSED BY VALUE
        // enums can also have functions/methods
    }
    
    /*func performOperation(symbol: String) {
     /*let constant = operations[symbol]
     accumulator = constant!*/  // this is dangerous because maybe someone is using my API and they're using an operation that I don't understand, then I'm going to crash, so..
     if let constant = operations[symbol] {
     accumulator = constant
     }
     }*/
    
    func performOperation(_ symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            case .Clear:
                accumulator = 0.0
            }
        }
    }
    
    private func executePendingBinaryOperation()
    {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    // structs are PASSED BY VALUE
    // structs are like enums
    // structs have a free initializer that initializes all of its vars i.e. myStruct(var1, var2, var3)
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    typealias PropertyList = AnyObject  // this is a way to document
    
    var program: PropertyList {
        get {
            return internalProgram as CalculatorBrain.PropertyList  // returning a COPY of internalProgram, not a pointer
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand)
                    } else if let operation = op as? String {
                        performOperation(operation)
                    }
                }
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    // this is a read-only property (noticed the omission of the setter method)
    var result: Double {
        get {
            return accumulator
        }
    }
}
