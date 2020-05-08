//
//  MainViewController.swift
//  Calculator
//
//  Created by Mustafa on 7/5/20.
//  Copyright © 2020 Mustafa Nafie. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

	private lazy var mainView = view as! MainView
	
	private var firstOperand = 0
	private var secondOperand: Int? {
		didSet {
			if secondOperand != nil {
				mainView.equalsButton.isEnabled = true
			} else {
				mainView.equalsButton.isEnabled = false
			}
		}
	}
	private var operation: String? {
		didSet {
			if let operation = operation {
				mainView.deselectButton(operation: oldValue ?? "")
				mainView.selectButton(operation: operation)
				mainView.secondOperandTextField.isEnabled = true
			} else {
				mainView.deselectButton(operation: oldValue ?? "")
				mainView.secondOperandTextField.isEnabled = false
			}
		}
	}
	
	private var operationsHistory: [(operation: String, operand: Int)]!
	
	private var undoPointer = -1 {
		didSet {
			if undoPointer == -1 {
				mainView.toggleUndoButton(isEnabled: false)
			} else {
				mainView.toggleUndoButton(isEnabled: true)
			}
		}
	}
	
	private var redoOperations: [(operation: String, operand: Int)]! {
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
		view = MainView(frame: CGRect())
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		setupTextField()
		setupCollectionView()
		attachTargetsToButtons()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		test()
	}

}

// MARK: - Actions

extension MainViewController {
	
	@objc func operationButtonTapped(sender: UIButton) {
		operation = sender.titleLabel?.text
		print("\(operation!) Button Tapped!")
	}
	
	@objc func equalsButtonTapped(sender: UIButton) {
		print("Equals Button Tapped!")
		var result: Int!
		switch operation {
		case "+":
			result = firstOperand + (secondOperand!)
		case "-":
			result = firstOperand - (secondOperand!)
		case "*":
			result = firstOperand * (secondOperand!)
		case "/":
			result = firstOperand / (secondOperand!)
		default:
			break
		}
		
		print("Operation Performed:", firstOperand, operation!, secondOperand!, "=", result!, "\n")
		
		if operationsHistory != nil {
			operationsHistory += [(operation!, secondOperand!)]
		} else {
			operationsHistory = [(operation!, secondOperand!)]
		}
		undoPointer = operationsHistory.count - 1
		
		mainView.historyCollectionView.insertItems(at: [IndexPath(item: operationsHistory.count-1, section: 0)])
		
		mainView.resultLabel.text = "Result = \(result!)"
		firstOperand = result
		mainView.secondOperandTextField.text = ""
		operation = nil
		secondOperand = nil
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
		cell.resultLabel.text = "\(operationsHistory[indexPath.item].operation)\(operationsHistory[indexPath.item].operand)"
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
		switch operation.operation {
		case "+":
			result = firstOperand - operation.operand
			operationsHistory += [("-", operation.operand)]
		case "-":
			result = firstOperand + operation.operand
			operationsHistory += [("+", operation.operand)]
		case "*":
			result = firstOperand / operation.operand
			operationsHistory += [("/", operation.operand)]
		case "/":
			result = firstOperand * operation.operand
			operationsHistory += [("*", operation.operand)]
		default:
			break
		}
		
		print("Undo Performed:", firstOperand, operation.operation, operation.operand, "=", result!, "\n")

		firstOperand = result
		mainView.resultLabel.text = "Result = \(result!)"
		
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
		var result: Int!
		switch operation.operation {
		case "+":
			result = firstOperand + operation.operand
		case "-":
			result = firstOperand - operation.operand
		case "*":
			result = firstOperand * operation.operand
		case "/":
			result = firstOperand / operation.operand
		default:
			break
		}
		
		print("Redo Performed:", firstOperand, operation.operation, operation.operand, "=", result!, "\n")
		
		firstOperand = result
		mainView.resultLabel.text = "Result = \(result!)"
		
		if operationsHistory != nil {
			operationsHistory += [operation]
		} else {
			operationsHistory = [operation]
		}
		
		undoPointer = operationsHistory.count - 1
		mainView.historyCollectionView.insertItems(at: [IndexPath(item: operationsHistory.count-1, section: 0)])
	}
	
	func test() {
		// Add 3
		mainView.operationsButtons["+"]!.sendActions(for: .touchUpInside)
		secondOperand = 3
		mainView.equalsButton.sendActions(for: .touchUpInside)
		assert(mainView.resultLabel.text == "Result = 3")
		// Add 2
		mainView.operationsButtons["+"]!.sendActions(for: .touchUpInside)
		secondOperand = 2
		mainView.equalsButton.sendActions(for: .touchUpInside)
		assert(mainView.resultLabel.text == "Result = 5")
		// Multiply by 5
		mainView.operationsButtons["*"]!.sendActions(for: .touchUpInside)
		secondOperand = 5
		mainView.equalsButton.sendActions(for: .touchUpInside)
		assert(mainView.resultLabel.text == "Result = 25")
		// Undo Twice
		mainView.historyButtons[0].sendActions(for: .touchUpInside)
		mainView.historyButtons[0].sendActions(for: .touchUpInside)
		assert(mainView.resultLabel.text == "Result = 3")
		// Redo
		mainView.historyButtons[1].sendActions(for: .touchUpInside)
		assert(mainView.resultLabel.text == "Result = 5")
		// Add 3
		mainView.operationsButtons["+"]!.sendActions(for: .touchUpInside)
		secondOperand = 3
		mainView.equalsButton.sendActions(for: .touchUpInside)
		assert(mainView.resultLabel.text == "Result = 8")
		// Undo 4 times
		mainView.historyButtons[0].sendActions(for: .touchUpInside)
		mainView.historyButtons[0].sendActions(for: .touchUpInside)
		mainView.historyButtons[0].sendActions(for: .touchUpInside)
		mainView.historyButtons[0].sendActions(for: .touchUpInside)
		assert(mainView.resultLabel.text == "Result = 25")
		
		print("Test case passed!")
	}
	
}

