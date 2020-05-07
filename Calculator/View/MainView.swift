//
//  MainView.swift
//  Calculator
//
//  Created by Mustafa on 7/5/20.
//  Copyright © 2020 Mustafa Nafie. All rights reserved.
//

import UIKit

class MainView: UIView {
	
	private let resultLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.text = "Result"
		label.font = .systemFont(ofSize: 30)
		return label
	}()
	
	private let secondOperandTextField: UITextField = {
		let textField = UITextField()
		textField.translatesAutoresizingMaskIntoConstraints = false
		textField.placeholder = "Please Enter the Second Operand"
		textField.font = .systemFont(ofSize: 17)
		textField.textAlignment = .center
		textField.borderStyle = .roundedRect
		textField.keyboardType = .numberPad
		return textField
	}()
	
}

// MARK: - Helper functions

extension MainView {
	
	func setupView() {
		setupUI()
		setupLayout()
	}
	
	private func setupUI() {
		addSubview(resultLabel)
		addSubview(secondOperandTextField)
	}
	
	private func setupLayout() {
		// Result Label
		NSLayoutConstraint.activate([
			resultLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
			resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
		// Second Operand TextField
		NSLayoutConstraint.activate([
			secondOperandTextField.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
			secondOperandTextField.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
	}
	
}

