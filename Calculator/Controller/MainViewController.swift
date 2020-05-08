//
//  MainViewController.swift
//  Calculator
//
//  Created by Mustafa on 7/5/20.
//  Copyright © 2020 Mustafa Nafie. All rights reserved.
//

import UIKit

typealias Operation = (operator: String, secondOperand: Int)

class MainViewController: UIViewController {

	private lazy var mainView = view as! MainView
	
	var firstOperand = 0
	var secondOperand: Int? {
		didSet {
			if secondOperand != nil {
				mainView.equalsButton.isEnabled = true
			} else {
				mainView.equalsButton.isEnabled = false
			}
		}
	}
	private var selectedOperator: String? {
		didSet {
			if let operation = selectedOperator {
				mainView.deselectButton(operation: oldValue ?? "")
				mainView.selectButton(operation: operation)
				mainView.secondOperandTextField.isEnabled = true
			} else {
				mainView.deselectButton(operation: oldValue ?? "")
				mainView.secondOperandTextField.isEnabled = false
			}
		}
	}
	
	private var operationsHistory: [Operation]!
	
	private var undoPointer = -1 {
		didSet {
			if undoPointer == -1 {
				mainView.toggleUndoButton(isEnabled: false)
			} else {
				mainView.toggleUndoButton(isEnabled: true)
			}
		}
	}
	
	private var redoOperations: [Operation]! {
		didSet {
//			print("Redo Operations: \(redoOperations!)")
			if redoOperations.isEmpty {
				mainView.toggleRedoButton(isEnabled: false)
			} else {
				mainView.toggleRedoButton(isEnabled: true)
			}
		}
	}

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
		selectedOperator = sender.titleLabel?.text
		print("\(selectedOperator!) Button Tapped!")
	}
	
	@objc func equalsButtonTapped(sender: UIButton) {
		print("Equals Button Tapped!")
		let operation = (operator: selectedOperator!, secondOperand: secondOperand!)
		let result = performOperation(operation: operation)
		updateResult(result: result)
		updateHistory(operation: operation)
	}
	
	@objc func historyButtonTapped(sender: UIButton) {
		let action = sender.titleLabel?.text
		print("\(action!) Button Tapped!")
		if action == "Undo" {
			undoOperation(at: operationsHistory.count - 1)
		} else {
			redoOperation()
		}
	}
	
}

// MARK: - TextField Delegate

extension MainViewController: UITextFieldDelegate {
	
	func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		defer {
			print("secondOperand:", secondOperand)
		}
		// Enables deleting a number
		if string.isEmpty {
			// Change secondOperand to nil if TextField is empty
			if textField.text?.count == 1 {
				secondOperand = nil
			}
			return true
		}
		// Accepts numbers only
		if Int(string) != nil {
			secondOperand = Int((textField.text! + string))
			print("secondOperand:", secondOperand)
			return true
		}
		return false
	}
	
}

// MARK: - CollectionView DataSource

extension MainViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		guard operationsHistory != nil else {return 0}
		return operationsHistory.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath) as! CollectionViewCell
		cell.resultLabel.text = "\(operationsHistory[indexPath.item].operator)\(operationsHistory[indexPath.item].secondOperand)"
		return cell
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		undoOperation(at: indexPath.item)
	}
	
}

// MARK: - CollectionView Delegate

extension MainViewController: UICollectionViewDelegate {
	
	
	
}

// MARK: - Helper functions

extension MainViewController {
	
	private func setupTextField() {
		mainView.secondOperandTextField.delegate = self
	}
	
	private func setupCollectionView() {
		mainView.historyCollectionView.delegate = self
		mainView.historyCollectionView.dataSource = self
		mainView.historyCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cellIdentifier")
	}
	
	private func attachTargetsToButtons() {
		for (_, button) in mainView.operationsButtons {
			button.addTarget(self, action: #selector(operationButtonTapped(sender:)), for: .touchUpInside)
		}
		for button in mainView.historyButtons {
			button.addTarget(self, action: #selector(historyButtonTapped(sender:)), for: .touchUpInside)
		}
		mainView.equalsButton.addTarget(self, action: #selector(equalsButtonTapped(sender:)), for: .touchUpInside)
	}
	
	private func undoOperation(at index: Int) {
		let operation = operationsHistory[undoPointer]
		var result: Int!
		switch operation.operator {
		case "+":
			result = firstOperand - operation.secondOperand
			operationsHistory += [("-", operation.secondOperand)]
		case "-":
			result = firstOperand + operation.secondOperand
			operationsHistory += [("+", operation.secondOperand)]
		case "*":
			result = firstOperand / operation.secondOperand
			operationsHistory += [("/", operation.secondOperand)]
		case "/":
			result = firstOperand * operation.secondOperand
			operationsHistory += [("*", operation.secondOperand)]
		default:
			break
		}
		
		print("Undo Performed:", firstOperand, operation.operator, operation.secondOperand, "=", result!, "\n")

		updateResult(result: result)
		
		if redoOperations != nil {
			redoOperations += [operation]
		} else {
			redoOperations = [operation]
		}
		
		undoPointer -= 1
		mainView.historyCollectionView.insertItems(at: [IndexPath(item: operationsHistory.count-1, section: 0)])
	}
	
	private func redoOperation() {
		let operation = redoOperations.removeLast()
		let result = performOperation(operation: operation)
		updateResult(result: result)
		updateHistory(operation: operation)
	}
	
	private func performOperation(operation: Operation) -> Int {
		var result = 0
		switch operation.operator {
		case "+":
			result = firstOperand + operation.secondOperand
		case "-":
			result = firstOperand - operation.secondOperand
		case "*":
			result = firstOperand * operation.secondOperand
		case "/":
			result = firstOperand / operation.secondOperand
		default:
			break
		}
		
		print("Operation Performed:", firstOperand, operation.operator, operation.secondOperand, "=", result, "\n")
		
		return result
	}
	
	private func updateHistory(operation: Operation) {
		if operationsHistory != nil {
			operationsHistory += [operation]
		} else {
			operationsHistory = [operation]
		}
		undoPointer = operationsHistory.count - 1
		mainView.historyCollectionView.insertItems(at: [IndexPath(item: operationsHistory.count-1, section: 0)])
	}
	
	private func updateResult(result: Int) {
		mainView.resultLabel.text = "Result = \(result)"
		firstOperand = result
		mainView.secondOperandTextField.text = ""
		selectedOperator = nil
		secondOperand = nil
	}
	
}

