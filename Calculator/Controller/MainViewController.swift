//
//  MainViewController.swift
//  Calculator
//
//  Created by Mustafa on 7/5/20.
//  Copyright © 2020 Mustafa Nafie. All rights reserved.
//

import UIKit

typealias Operation = (operator: Constants.Operators, secondOperand: Int)

class MainViewController: UIViewController {

	// MARK: - Properties

	private lazy var mainView = view as! MainView
	
	var firstOperand = 0
	var secondOperand: Int? {
		didSet { secondOperandChanged() }
	}
	private var selectedOperator: Constants.Operators? {
		didSet { selectedOperatorChanged(oldValue: oldValue) }
	}
	private var undoPointer = -1 {
		didSet { undoPointerChanged() }
	}
	private var operationsHistory: [Operation]!
	private var redoOperations: [Operation]! {
		didSet { redoOperationsChanged() }
	}
	
	// MARK: - View Lifecycle

	override func loadView() {
		super.loadView()
		
		view = MainView(frame: CGRect())
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		setupTextField()
		setupCollectionView()
		attachTargetsToButtons()
	}

}

// MARK: - Actions

extension MainViewController {
	
	@objc func operationButtonTapped(sender: UIButton) {
		selectedOperator = Constants.Operators(rawValue: (sender.titleLabel?.text)!)!
		print("\(selectedOperator!) Button Tapped!")
	}
	
	@objc func equalsButtonTapped(sender: UIButton) {
		print("Equals Button Tapped!")
		if let selectedOperator = selectedOperator, let secondOperand = secondOperand {
			let operation = (operator: selectedOperator, secondOperand: secondOperand)
			let result = performOperation(operation)
			updateResult(result: result)
			updateHistory(operation: operation)
		}
	}
	
	@objc func historyButtonTapped(sender: UIButton) {
		let action = Constants.Operators(rawValue: (sender.titleLabel?.text)!)!
		print("\(action.rawValue) Button Tapped!")
		if action == .undo {
			undoOperation(at: undoPointer)
		} else {
			redoOperation()
		}
	}
	
}

// MARK: - TextField Delegate

extension MainViewController: UITextFieldDelegate {
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		return isValidNumber(string, in: textField)
	}
	
}

// MARK: - CollectionView DataSource

extension MainViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard operationsHistory != nil else {return 0}
		return operationsHistory.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.cellIdentifier, for: indexPath) as! OperationCell
		cell.setOperation(operationsHistory.last!)
		return cell
	}
	
}

// MARK: - CollectionView Delegate

extension MainViewController: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		undoOperation(at: operationsHistory.count - 1 - indexPath.item)
	}
	
}

// MARK: - Operations

extension MainViewController {
	
	private func undoOperation(at index: Int) {
		let operation = operationsHistory[index]
		let reversedOperation = reverseOperation(operation)
		let result = performOperation(reversedOperation)
		updateResult(result: result)
		updateUndoHistory(operation: operation)
	}
	
	private func redoOperation() {
		let operation = redoOperations.removeLast()
		let result = performOperation(operation)
		updateResult(result: result)
		updateHistory(operation: operation)
	}
	
	private func performOperation(_ operation: Operation) -> Int {
		var result = 0
		switch operation.operator {
		case .addition:
			result = firstOperand + operation.secondOperand
		case .subtraction:
			result = firstOperand - operation.secondOperand
		case .multiplication:
			result = firstOperand * operation.secondOperand
		case .division:
			result = firstOperand / operation.secondOperand
		default:
			break
		}
		
		print("Operation Performed:", firstOperand, operation.operator.rawValue, operation.secondOperand, "=", result, "\n")
		
		return result
	}
	
	private func reverseOperation(_ operation: Operation) -> Operation {
		var operation = operation
		switch operation.operator {
		case .addition:
			operation.operator = .subtraction
		case .subtraction:
			operation.operator = .addition
		case .multiplication:
			operation.operator = .division
		case .division:
			operation.operator = .multiplication
		default:
			break
		}
		operationsHistory += [operation]
		return operation
	}
	
	private func updateHistory(operation: Operation) {
		if operationsHistory != nil {
			operationsHistory += [operation]
		} else {
			operationsHistory = [operation]
		}
		undoPointer = operationsHistory.count - 1
		mainView.historyCollectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
	}
	
	private func updateUndoHistory(operation: Operation) {
		if redoOperations != nil {
			redoOperations += [operation]
		} else {
			redoOperations = [operation]
		}
		undoPointer -= 1
		mainView.historyCollectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
	}
	
	private func updateResult(result: Int) {
		mainView.showResult(result)
		firstOperand = result
		mainView.setTextFieldText("")
		selectedOperator = .none
		secondOperand = nil
	}
	
}

// MARK: - Bindings

extension MainViewController {
	
	private func selectedOperatorChanged(oldValue: Constants.Operators?) {
		mainView.selectButton(selectedOperator: selectedOperator, previousOperator: oldValue)
		let isEnabled = (selectedOperator != nil)
		mainView.toggleTextField(isEnabled: isEnabled)
	}
	
	private func undoPointerChanged() {
		let isEnabled = (undoPointer > -1)
		mainView.toggleButton(buttonName: .undo, isEnabled: isEnabled)
	}
	
	private func secondOperandChanged() {
		let isEnabled = (secondOperand != nil)
		mainView.toggleButton(buttonName: .equal, isEnabled: isEnabled)
	}
	
	private func redoOperationsChanged() {
		//		print("Redo Operations: \(redoOperations!)")
		let isEnabled = !(redoOperations.isEmpty)
		mainView.toggleButton(buttonName: .redo, isEnabled: isEnabled)
	}
	
}


// MARK: - Helper functions

extension MainViewController {
	
	private func setupTextField() {
		mainView.setTextFieldDelegate(self)
	}
	
	private func setupCollectionView() {
		mainView.historyCollectionView.delegate = self
		mainView.historyCollectionView.dataSource = self
		mainView.historyCollectionView.register(OperationCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
	}
	
	private func attachTargetsToButtons() {
		for (buttonName, button) in mainView.operatorButtons {
			if buttonName == .redo || buttonName == .undo {
				button.addTarget(self, action: #selector(historyButtonTapped(sender:)), for: .touchUpInside)
			} else if buttonName == .equal {
				button.addTarget(self, action: #selector(equalsButtonTapped(sender:)), for: .touchUpInside)
			} else {
				button.addTarget(self, action: #selector(operationButtonTapped(sender:)), for: .touchUpInside)
			}
		}
	}
	
	private func isValidNumber(_ string: String, in textField: UITextField) -> Bool {
		// Accepts numbers only
		if Int(string) != nil {
			secondOperand = Int((textField.text! + string))
			return true
		}
		// Enables deleting a number
		if string.isEmpty {
			// Change secondOperand to nil if TextField is empty
			if textField.text?.count == 1 {
				secondOperand = nil
			}
			return true
		}
		return false
	}
	
}

