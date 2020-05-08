//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Mustafa on 8/5/20.
//  Copyright © 2020 Mustafa Nafie. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {
	
	let mainViewController = MainViewController()
	let addButton = UIButton()
	let subButton = UIButton()
	let multButton = UIButton()
	let divButton = UIButton()
	let undoButton = UIButton()
	let redoButton = UIButton()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
		addButton.titleLabel?.text = Constants.Operators.addition.rawValue
		subButton.titleLabel?.text = Constants.Operators.subtraction.rawValue
		multButton.titleLabel?.text = Constants.Operators.multiplication.rawValue
		divButton.titleLabel?.text = Constants.Operators.division.rawValue
		undoButton.titleLabel?.text = Constants.Operators.undo.rawValue
		redoButton.titleLabel?.text = Constants.Operators.redo.rawValue
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
	
	func testScenario() throws {
		// Add 3
		mainViewController.operationButtonTapped(sender: addButton)
		mainViewController.secondOperand = 3
		mainViewController.equalsButtonTapped(sender: UIButton())
		XCTAssertEqual(mainViewController.firstOperand, 3)
		// Add 2
		mainViewController.operationButtonTapped(sender: addButton)
		mainViewController.secondOperand = 2
		mainViewController.equalsButtonTapped(sender: UIButton())
		XCTAssertEqual(mainViewController.firstOperand, 5)
		// Multiply by 5
		mainViewController.operationButtonTapped(sender: multButton)
		mainViewController.secondOperand = 5
		mainViewController.equalsButtonTapped(sender: UIButton())
		XCTAssertEqual(mainViewController.firstOperand, 25)
		// Undo Twice
		mainViewController.historyButtonTapped(sender: undoButton)
		mainViewController.historyButtonTapped(sender: undoButton)
		XCTAssertEqual(mainViewController.firstOperand, 3)
		// Redo
		mainViewController.historyButtonTapped(sender: redoButton)
		XCTAssertEqual(mainViewController.firstOperand, 5)
		// Add 3
		mainViewController.operationButtonTapped(sender: addButton)
		mainViewController.secondOperand = 3
		mainViewController.equalsButtonTapped(sender: UIButton())
		XCTAssertEqual(mainViewController.firstOperand, 8)
		// Undo 4 times
		mainViewController.historyButtonTapped(sender: undoButton)
		mainViewController.historyButtonTapped(sender: undoButton)
		mainViewController.historyButtonTapped(sender: undoButton)
		mainViewController.historyButtonTapped(sender: undoButton)
		XCTAssertEqual(mainViewController.firstOperand, 25)
	}

}
