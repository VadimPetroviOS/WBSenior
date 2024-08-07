//
//  CalculatorViewModel.swift
//  WBSenior
//
//  Created by Вадим on 07.08.2024.
//

import Foundation

final class CalculatorViewModel: ObservableObject {
    @Published
    var text: String = ""
    
    func appendNumberOrOperation(_ element: String) {
        if element == "=" {
            text = evaluateExpression(text)
        } else if element == "C"{
            text = ""
        } else {
            text.append(element)
        }
    }
    
    private func evaluateExpression(_ expression: String) -> String {
        func infixToPostfix(_ expression: String) -> [String] {
            let operators = Set("+-x/")
            let precedence: [Character: Int] = ["+": 1, "-": 1, "x": 2, "/": 2]
            var output = [String]()
            var stack = [Character]()
            
            var number = ""
            for char in expression {
                if char.isNumber || char == "." {
                    number.append(char)
                } else {
                    if !number.isEmpty {
                        output.append(number)
                        number = ""
                    }
                    if operators.contains(char) {
                        while let last = stack.last, operators.contains(last), precedence[char]! <= precedence[last]! {
                            output.append(String(stack.removeLast()))
                        }
                        stack.append(char)
                    }
                }
            }
            
            if !number.isEmpty {
                output.append(number)
            }
            
            while let last = stack.last {
                output.append(String(stack.removeLast()))
            }
            
            return output
        }
        
        // обратная польская нотация
        func evaluatePostfix(_ tokens: [String]) -> Double? {
            var stack = [Double]()
            
            for token in tokens {
                if let number = Double(token) {
                    stack.append(number)
                } else {
                    guard let right = stack.popLast(), let left = stack.popLast() else {
                        return nil
                    }
                    switch token {
                    case "+":
                        stack.append(left + right)
                    case "-":
                        stack.append(left - right)
                    case "x":
                        stack.append(left * right)
                    case "/":
                        stack.append(left / right)
                    default:
                        return nil
                    }
                }
            }
            
            return stack.last
        }
        
        let postfix = infixToPostfix(expression)
        if let result = evaluatePostfix(postfix) {
                return "\(result)"
            } else {
                return "Ошибка в выражении"
            }
    }
}
