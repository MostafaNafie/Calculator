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
	
	private let buttonsStackView: UIStackView = {
		let stackView = UIStackView()
		stackView.translatesAutoresizingMaskIntoConstraints = false
		stackView.distribution = .equalSpacing
		return stackView
	}()
	
	private let undoButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Undo", for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 17)
		return button
	}()
	
	private let additionButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("+", for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 17)
		return button
	}()
	
	private let substractionButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("-", for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 17)
		return button
	}()
	
	private let multiplicationButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("*", for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 17)
		return button
	}()
	
	private let divisionButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("/", for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 17)
		return button
	}()
	
	private let equalsButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("=", for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 17)
		return button
	}()
	
	private let redoButton: UIButton = {
		let button = UIButton(type: .system)
		button.setTitle("Redo", for: .normal)
		button.titleLabel?.font = .boldSystemFont(ofSize: 17)
		return button
	}()
	
	let historyCollectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		layout.itemSize = CGSize(width: 50, height: 50)
		let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		collectionView.backgroundColor = .black
		return collectionView
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
		addSubview(buttonsStackView)
		
		buttonsStackView.addArrangedSubview(undoButton)
		buttonsStackView.addArrangedSubview(additionButton)
		buttonsStackView.addArrangedSubview(substractionButton)
		buttonsStackView.addArrangedSubview(multiplicationButton)
		buttonsStackView.addArrangedSubview(divisionButton)
		buttonsStackView.addArrangedSubview(equalsButton)
		buttonsStackView.addArrangedSubview(redoButton)
		
		addSubview(historyCollectionView)
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
		// Buttons StackView
		NSLayoutConstraint.activate([
			buttonsStackView.topAnchor.constraint(equalTo: secondOperandTextField.bottomAnchor, constant: 20),
			buttonsStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
			buttonsStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20)
		])
		// History CollectionView
		NSLayoutConstraint.activate([
			historyCollectionView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: 20),
			historyCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 20),
			historyCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -20),
			historyCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
		])
	}
	
}
