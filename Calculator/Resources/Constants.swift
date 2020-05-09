//
//  Constants.swift
//  Calculator
//
//  Created by Mustafa on 8/5/20.
//  Copyright © 2020 Mustafa Nafie. All rights reserved.
//

import UIKit

struct Constants {
	
	// Fonts
	static let fontSize: CGFloat = 17
	static let resultFontSize: CGFloat = 30
	// Margins and Padding
	static let defaultMargin: CGFloat = 20
	static let cellMargin: CGFloat = 10
	static let cellPadding: CGFloat = 5
	// Identifiers
	static let cellIdentifier = "OperationCell"
	// Strings
	enum Strings: String {
		case result = "Result"
		case secondOperandPlaceholder = "Please Enter the Second Operand"
	}
	// Buttons' Names
	enum Operators: String, CaseIterable {
		case undo = "Undo"
		case addition = "+"
		case subtraction = "-"
		case multiplication = "*"
		case division = "/"
		case equal = "="
		case redo = "Redo"
	}
	
}
