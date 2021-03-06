//
//  MainView.swift
//  Calculator
//
//  Created by Mustafa on 7/5/20.
//  Copyright © 2020 Mustafa Nafie. All rights reserved.
//

import UIKit

typealias Buttons = [Constants.Operators: UIButton]

class MainView: UIView {
	
	// MARK: - Views

	private lazy var resultLabel = setupLabel()
	private lazy var secondOperandTextField = setupTextField()
	private lazy var buttonsStackView = setupStackView()
	private lazy var operatorButtons = setupButtons()
	private lazy var historyCollectionView = setupCollectionView()
	
	// MARK: - Initializers
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		setupLayout()
	}
	
}

// MARK: - Encapsulation

extension MainView {
	
	func showResult(_ result: Int) {
		resultLabel.text = "\(Constants.Strings.result.rawValue) = \(result)"
	}
	
	func setTextFieldDelegate(to viewController: UIViewController) {
		secondOperandTextField.delegate = (viewController as! UITextFieldDelegate)
	}
	
	func setTextFieldText(_ text: String) {
		secondOperandTextField.text = text
	}
	
	func toggleTextField(isEnabled: Bool) {
		secondOperandTextField.isEnabled = isEnabled
	}
	
	func getButtons() -> Buttons {
		return operatorButtons
	}
	
	func selectButton(selectedOperator: Constants.Operators?, previousOperator: Constants.Operators?) {
		if  let selectedOperator = selectedOperator, let button = operatorButtons[selectedOperator] {
			button.backgroundColor = .lightGray
			button.tintColor = .white
		}
		if let previousOperator = previousOperator, let button = operatorButtons[previousOperator] {
			button.backgroundColor = nil
			button.tintColor = .systemBlue
		}
	}
	
	func toggleButton(buttonName: Constants.Operators, isEnabled: Bool) {
		operatorButtons[buttonName]!.isEnabled = isEnabled
	}
	
	func attachCollectionView(to viewController: UIViewController) {
		historyCollectionView.delegate = (viewController as! UICollectionViewDelegate)
		historyCollectionView.dataSource = (viewController as! UICollectionViewDataSource)
	}
	
	func updateCollectionView() {
		historyCollectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
	}
	
}

// MARK: - Helper functions

extension MainView {
	
	private func setupUI() {
		backgroundColor = .white
		// Views
		setSubviewsForAutoLayout([resultLabel, secondOperandTextField, buttonsStackView, historyCollectionView])
		// Buttons
		Constants.Operators.allCases.forEach { buttonsStackView.addArrangedSubview(operatorButtons[$0]!) }
	}
	
	private func setupLayout() {
		// Result Label
		NSLayoutConstraint.activate([
			resultLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor,constant: Constants.defaultMargin),
			resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
		// Second Operand TextField
		NSLayoutConstraint.activate([
			secondOperandTextField.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: Constants.defaultMargin),
			secondOperandTextField.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
		// Buttons StackView
		NSLayoutConstraint.activate([
			buttonsStackView.topAnchor.constraint(equalTo: secondOperandTextField.bottomAnchor, constant: Constants.defaultMargin),
			buttonsStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.defaultMargin),
			buttonsStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.defaultMargin)
		])
		// History CollectionView
		NSLayoutConstraint.activate([
			historyCollectionView.topAnchor.constraint(equalTo: buttonsStackView.bottomAnchor, constant: Constants.defaultMargin),
			historyCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.defaultMargin),
			historyCollectionView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: Constants.defaultMargin),
			historyCollectionView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -Constants.defaultMargin)
		])
		// Cell Size
		setupCellSize(in: historyCollectionView)
	}
	
	private func setupLabel() -> UILabel {
		let label = UILabel()
		label.text = Constants.Strings.result.rawValue
		label.font = .systemFont(ofSize: Constants.resultFontSize)
		return label
	}
	
	private func setupTextField() -> UITextField {
		let textField = UITextField()
		textField.placeholder = Constants.Strings.secondOperandPlaceholder.rawValue
		textField.font = .systemFont(ofSize: Constants.fontSize)
		textField.textAlignment = .center
		textField.borderStyle = .roundedRect
		textField.keyboardType = .numberPad
		textField.isEnabled = false
		return textField
	}
	
	private func setupStackView() -> UIStackView {
		let stackView = UIStackView()
		stackView.distribution = .equalSpacing
		return stackView
	}
	
	private func setupButtons() -> Buttons {
		var buttonsDict = Buttons()
		for buttonName in Constants.Operators.allCases {
			let button: UIButton = {
				let button = UIButton(type: .system)
				button.setTitle(buttonName.rawValue, for: .normal)
				button.titleLabel?.font = .boldSystemFont(ofSize: Constants.fontSize)
				if buttonName == .undo || buttonName == .equal || buttonName == .redo {
					button.isEnabled = false
				}
				return button
			}()
			buttonsDict[buttonName] = button
		}
		return buttonsDict
	}
	
	private func setupCollectionView() -> UICollectionView {
		let collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout())
		collectionView.backgroundColor = .black
		collectionView.register(OperationCell.self, forCellWithReuseIdentifier: Constants.cellIdentifier)
		return collectionView
	}
	
	private func setupCellSize(in collectionView: UICollectionView) {
		let numOfCells: CGFloat = 4.0
		let padding: CGFloat = Constants.cellMargin
		let paddingSpace: CGFloat = (Constants.defaultMargin * 2) + (padding * (numOfCells - 1))
		let collectionViewWidth = UIScreen.main.bounds.width - (Constants.defaultMargin * 2)
		let availableWidth = collectionViewWidth - paddingSpace
		let cellWidth = availableWidth / numOfCells
		
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
		layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
		layout.minimumInteritemSpacing = padding
		layout.minimumLineSpacing = padding
		
		collectionView.collectionViewLayout = layout
	}
	
}
