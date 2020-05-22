//
//  CalculatorLogic.swift
//  calculator
//
//  Created by Brian Sakhuja on 5/22/20.
//  Copyright © 2020 Brian Sakhuja. All rights reserved.
//

class CalculatorLogic {
    
    private var accumulator = 0.0
    
    func setOperand(operand: Double) {
        accumulator = operand
    }
    
    private struct pendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    private var pending: pendingBinaryOperationInfo?
    
    
    private func executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand, accumulator)
            pending = nil
        }
    }
    
    private var operations: Dictionary<CalculatorButton, Operation> = [
        .plus: Operation.BinaryOperation({$0 + $1}),
        .minus: Operation.BinaryOperation({$0 - $1}),
        .multiply: Operation.BinaryOperation({$0 * $1}),
        .divide: Operation.BinaryOperation({$0 / $1}),
        .plusMinus: Operation.UnaryOperation({-$0}),
        .percent: Operation.UnaryOperation({$0 / 100}),
        .equals: Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
    }
    
    func performOperation(buttonType: CalculatorButton) {
        if let operation = operations[buttonType] {
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = pendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation();
            }
        }
    }
    
    func clear () {
        accumulator = 0.0
        pending = nil
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
