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
	
	private var operationsHistory: [(operation: String, operand: Int)]! {
		didSet {
			if operationsHistory.isEmpty {
				mainView.toggleUndoButton(isEnabled: false)
			} else {
				mainView.toggleUndoButton(isEnabled: true)
			}
		}
	}
	
	private var redoOperations: [(operation: String, operand: Int)]! {
		didSet {
			print("Redo: \(redoOperations!)")
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

}

// MARK: - Actions

extension MainViewController {
	
	@objc func operationButtonTapped(sender: UIButton) {
		operation = sender.titleLabel?.text
		print("\(operation!) Button Tapped")
	}
	
	@objc func equalsButtonTapped(sender: UIButton) {
		print("Equals Button Tapped")
		print(operation)
		var result: Int!
		switch operation {
		case "+":
			result = firstOperand + (secondOperand ?? 0)
		default:
			break
		}
		
		if operationsHistory != nil {
			operationsHistory += [(operation!, secondOperand!)]
		} else {
			operationsHistory = [(operation!, secondOperand!)]
		}
		
		mainView.historyCollectionView.insertItems(at: [IndexPath(item: operationsHistory.count-1, section: 0)])
		
		mainView.resultLabel.text = "Result = \(result!)"
		firstOperand = result
		mainView.secondOperandTextField.text = ""
		operation = nil
		secondOperand = nil
	}
	
	@objc func historyButtonTapped(sender: UIButton) {
		let action = sender.titleLabel?.text
		if action == "Undo" {
			undoOperation(at: operationsHistory.count - 1)
		} else {
			// Redo
		}
		print("\(action!) Button Tapped")
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
		let operation = operationsHistory[index]
		// TODO: Use switch statement
		if operation.operation == "+" {
			mainView.resultLabel.text = "Result = \(firstOperand - operation.operand)"
			firstOperand = firstOperand - operation.operand
		}
		
		if redoOperations != nil {
			redoOperations += [operationsHistory.remove(at: index)]
		} else {
			redoOperations = [operationsHistory.remove(at: index)]
		}
		
		mainView.historyCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
	}
	
}

