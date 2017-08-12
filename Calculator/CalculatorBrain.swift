//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Abdulmalek Albeik on 8/12/17.
//  Copyright © 2017 Abdulmelik. All rights reserved.
//

import Foundation

func changeSign(operand: Double) -> Double {
    return -operand
}

func multiply(op1:Double, op2:Double) -> Double{
    return op1*op2
}

struct  CalculatorBrain {
    
    private var accumulator: Double?
    
    private enum Operation{
        case constant(Double)
        case unaryOperation((Double) -> Double)
        case binaryOperation((Double,Double) -> Double)
        case equals
    }
    private var operations: Dictionary<String,Operation> =
        [
            "π" :Operation.constant(Double.pi),
            "e" :Operation.constant(M_E),
            "√" :Operation.unaryOperation(sqrt),
            "cos" :Operation.unaryOperation(cos),
            "±" :Operation.unaryOperation(changeSign),
            "×" :Operation.binaryOperation(multiply),
            "=" :Operation.equals

    ]
    
    mutating func performOperations(_ symbol: String)  {
        
        if let operation = operations[symbol]{
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unaryOperation(let function):
                if accumulator != nil{
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function):
                if accumulator != nil {
                    pendingBinaryOperation = pendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOperation()
                
            }
        }
    }
    
    
    private mutating func performPendingBinaryOperation() {
        if pendingBinaryOperation != nil && accumulator != nil{
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }

    private var pendingBinaryOperation: pendingBinaryOperation?
    
    private struct pendingBinaryOperation {
        let function: (Double,Double) -> Double
        let firstOperand: Double

        func perform(with secondOperand:Double ) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
    }
    
    var result: Double? {
        get{
            return accumulator
        }
    }
}