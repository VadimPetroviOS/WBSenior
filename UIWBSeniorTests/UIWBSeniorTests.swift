 //
 //  CalculatorViewUITests.swift
 //  WBSenior
 //
 //  Created by Вадим on 06.08.2024.
 //

 import XCTest

class CalculatorViewUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testAddition() {
        tapButtons("1", "+", "2", "=")
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "resultLabel").label, "3.0")
    }
    
    func testSubtraction() {
        tapButtons("5", "-", "3", "=")
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "resultLabel").label, "2.0")
    }
    
    func testMultiplication() {
        tapButtons("4", "x", "3", "=")
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "resultLabel").label, "12.0")
    }
    
    func testDivision() {
        tapButtons("8", "/", "2", "=")
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "resultLabel").label, "4.0")
    }
    
    func testClear() {
        tapButtons("9", "C")
        XCTAssertEqual(app.staticTexts.element(matching: .any, identifier: "resultLabel").label, "")
    }
    
    private func tapButtons(_ buttons: String...) {
        for button in buttons {
            app.buttons[button].tap()
        }
    }
}
