//
//  CalculatorTests.swift
//  WBSenior
//
//  Created by Вадим on 26.07.2024.
//

@testable import WBSenior
import XCTest
import Foundation


class CalculatorTests: XCTestCase {
    
    var calculator: Calculator!
    
    override func setUp() {
        super.setUp()
        calculator = Calculator()
    }
    
    override func tearDown() {
        calculator = nil
        super.tearDown()
    }
    
    func testAdd() {
        XCTAssertEqual(calculator.add(1, 1), 2)
        XCTAssertEqual(calculator.add(-1, 1), 0)
        XCTAssertEqual(calculator.add(-1, -1), -2)
    }
    
    func testSubtract() {
        XCTAssertEqual(calculator.subtract(2, 1), 1)
        XCTAssertEqual(calculator.subtract(1, 1), 0)
        XCTAssertEqual(calculator.subtract(-1, -1), 0)
    }
    
    func testMultiply() {
        XCTAssertEqual(calculator.multiply(2, 3), 6)
        XCTAssertEqual(calculator.multiply(-2, 3), -6)
        XCTAssertEqual(calculator.multiply(0, 3), 0)
    }
    
    func testDivide() {
        XCTAssertNoThrow(try {
            let result = try calculator.divide(6, 3).get()
            XCTAssertEqual(result, 2)
        }())
        
        XCTAssertNoThrow(try {
            let result = try calculator.divide(3, 2).get()
            XCTAssertEqual(result, 1.5)
        }())
        
        XCTAssertNoThrow(try {
            let result = try calculator.divide(-6, 3).get()
            XCTAssertEqual(result, -2)
        }())
        
        XCTAssertThrowsError(try calculator.divide(6, 0).get()) { error in
            XCTAssertEqual(error.localizedDescription, "Cannot divide by zero.")
        }
    }
}
