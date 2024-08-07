//
//  Calculator.swift
//  WBSenior
//
//  Created by Вадим on 26.07.2024.
//

import Foundation


enum CalculatorError: Error {
    case divisionByZero
}

extension CalculatorError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .divisionByZero:
            return NSLocalizedString("Cannot divide by zero.", comment: "Division by zero error")
        }
    }
}

final class Calculator {
    func add(_ lhs: Double, _ rhs: Double) -> Double {
        lhs + rhs
    }
    
    func subtract(_ lhs: Double, _ rhs: Double) -> Double {
        lhs - rhs
    }
    
    func multiply(_ lhs: Double, _ rhs: Double) -> Double {
        lhs * rhs
    }
    
    func divide(_ lhs: Double, _ rhs: Double) -> Result<Double, CalculatorError> {
        guard rhs != 0 else {
            return .failure(.divisionByZero)
        }
        return .success(lhs / rhs)
    }
}


