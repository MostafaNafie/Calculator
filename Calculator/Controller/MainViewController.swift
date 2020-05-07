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
	private var operation: String?

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
		
		mainView.resultLabel.text = "Result = \(result!)"
		firstOperand = result
		mainView.secondOperandTextField.text = ""
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
		return 5
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath)
		return cell
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
		mainView.additionButton.addTarget(self, action: #selector(operationButtonTapped(sender:)), for: .touchUpInside)
		mainView.substractionButton.addTarget(self, action: #selector(operationButtonTapped(sender:)), for: .touchUpInside)
		mainView.multiplicationButton.addTarget(self, action: #selector(operationButtonTapped(sender:)), for: .touchUpInside)
		mainView.divisionButton.addTarget(self, action: #selector(operationButtonTapped(sender:)), for: .touchUpInside)
		mainView.equalsButton.addTarget(self, action: #selector(equalsButtonTapped(sender:)), for: .touchUpInside)
	}
	
}

