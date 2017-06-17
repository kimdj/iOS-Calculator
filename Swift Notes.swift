//
//  Swift Notes.swift
//  Calculator
//
//  Created by macbookpro on 3/26/17.
//  Copyright © 2017 David Kim. All rights reserved.
//

import Foundation


class baseClass
{
    var propertyObserversAndOverrideExample: Int = 42 {
        willSet { /* new Value is the new value */ }
        didSet { /* oldValue is the old value */ }
    }
}

class foobar: baseClass
{
    func tupleExample() {
        func getSize() -> (weight: Int, height: Int) {
            return (280, 50)
        }
        
        let x = getSize()
        print("Weight: \(getSize().weight)\nHeight: \(getSize().height)")
        print("Weight: \(x.weight - 50)\nHeight: \(x.height - 50)")
    }
    
    func rangeExample() {
        /*
         struct Range<T> {
         var startIndex: T
         var endIndex: T
         }
         */
        
        // An array's range would be a Range<Int> (since arrays are indexed by Int
        
        let array = ["a","b","c","d"]
        let subArray1 = array[2...3]  // subArray1 will be ["c","d"]
        let subArray2 = array[2..<3]  // subArray2 will be ["c]
        print("subArray1: \(subArray1)\nsubArray2: \(subArray2)")
        
        for i in 27...104 {
            print("i is equal to \(i)\n")
        }  // Range is enumeratable, like Array, String, Dictionary
        
    }
    
    func underscoreExample() {
        // Because all parameters to all functions have an internal and an external name, you can use the _ to omit the argument label when invoking a function
        func sum(x: Int, y: Int) -> Int {
            return x + y
        }
        func product(_ x: Int, _ y: Int) -> Int {
            return x + y
        }
        print("The sum of 1 and 2 is equal to \(sum(x: 1, y: 2))")
        print("The product of 5 and 10 is equal to \(product(5, 10))")
        
        // _ can be used to omit tuple elements
        let myTuple = ("House", 10495, 600.0)
        print("\(myTuple.0)\n\(myTuple.1)\n\(myTuple.2)")
        let (a, b, _) = myTuple
        print(a)
        print(b)
        
        // _ can be used to skip function invocation result
        func area(_ x: Int, _ y: Int) -> Int {
            // Do Something
            return x * y
        }
        _ = area(2, 4)  // The return value is not used and thrown away
        
        // _ can be used to skip closure parameters
        let colors = ["green", "blue", "white", "yellow", "orange"]
        let evenColors = colors.enumerated().filter { index, _ in return index % 2 == 0 }.map {  value in value.1 }
        print(evenColors) // => ["green", "white", "orange"]
        
        // _ can be used to skip iteration values
        let base = 2
        let exponent = 5
        var power = 1
        for _ in 1...exponent {
            power *= base
        }
        print(power)  // => 32
    }
    
    override var propertyObserversAndOverrideExample: Int {
        willSet { /* new Value is the new value */ }
        didSet { /* oldValue is the old value */ }
    }
    
    var operations: Dictionary<String, Operation> = [:] {
        willSet { /* will be executed if an operation is added/removed */ }
        didSet { /* will be executed if an operation is added/removed */ }
    }
    
    /*
     A lazy property does not get initialized until someone accesses it
     // You can allocate an object:
     lazy var brain = CalculatorBrain()  // nice if CalculatorBrain uses lots of resources
     
     // Execute a closure:
     lazy var someProperty: Type = {
     // construct the value of someProperty here
     return <the constructed value>
     }()
     
     // Call a method if you want:
     lazy var myProperty = self.initializeMyProperty()
     
     This still satisfies the "you must initialize all of your properties" rule
     Unfortunately, things initialized this way can't be constants (i.e., var ok, let not ok)
     This can be used to get around some initialization dependency conundrums
     */
    
    /*
    func arrayExmaple() {
        // initializing an instance of an array of Strings
        var a = Array<String>()
        var b = [String]()
        
        a.append("First")
        b.append("Cat")
        
        // initializing an instance of an array of Doubles
        var i = Array<Double>()
        var j = [Double]()
        
        i.append(1.0)
        j.append(1.0)
        
        var x = [Double]()
        var y = [Double]()
        
        x.append(3.142)
        y.append(8.314)
        
        print(x[0])
        print(y[0])
        
        // Dictionary:
        var pac10teamRankings = Dictionary<String, Int>()
        var pac12teamRankings = [String:Int]()
        
        pac12teamRankings["a"] = 1
        
        pac10teamRankings = ["Stanford":1, "Cal":10]
        let ranking = pac10teamRankings["Ohio State"]  // ranking is an Int? (could be nil)
        print(ranking!)
        
        // use a tuple with for-in loop to enumerate a Dictionary:
        for (key, value) in pac10teamRankings {
            print("\(key) = \(value)")
        }
        
        var scientificConstants: [String:Double] = [:]
        scientificConstants["Gas Constant"] = 5.5
        scientificConstants.updateValue(3.3, forKey: "PI")
        
        let animals = ["Giraffe", "Cow", "Dog", "Bird"]
        for animal in animals {
            print("\(animal)")
        }
        var d = 0
        for _ in animals {
            print("\(animals[d])")
            d = d + 1
        }
        
        // Interesting Array<T> methods:
        
        // create a new array with any "undesirables" filtered out
        // someArray.filter(includeElement: (Int) -> Bool) -> [Int]
        let bigNumbers = [2, 47, 118, 5, 9].filter({ $0 > 20 })
        print("\(bigNumbers)")
        
        // create a new array by transforming each element to something different
        // the thing it is transformed to can be of a different type than what is in the array
        // someArray.map(transform: (T) -> U) -> [U]
        let stringified: [String] = [1,2,3].map { String($0) }  // NOTICE: no parenthesis around the curly brackets => parenthesis are OPTIONAL when a closure is the last argument of a function
        print("\(stringified)")
        
        // reduce an entire array to a single value
        // someArray.reduce(initial: U, combine: (U, T) -> U) -> U
        let sum: Int = [1,2,3].reduce(0) { $0 + $1 }
        print(sum)  // 6
        
        // Strings:
        // the simplest way to deal with the chars in a string is via this property ...
        // var characters: String.CharacterView { get }
        // this is not actually an array of characters, but an array of character representations
        
        /*
         .startIndex -> String.Index
         .endIndex -> String.Index
         .hasPrefix(String) -> Bool
         .hasSuffix(String) -> Bool
         .capitalizedString -> String
         .lowercaseString -> String
         .uppercaseString -> String
         .componentsSeparatedByString(String) -> [String]  // "1,2,3".csbs(",") = ["1","2","3"] 
 */
 
    }*/
}

/*
 
 let newView = UIView(frame: myViewFrame)  // create a UIView via code
 
 override func drawRect(regionThatNeedsToBeDrawn: CGRect)  // to draw, create a UIView subclass and override drawRect
 
 */
