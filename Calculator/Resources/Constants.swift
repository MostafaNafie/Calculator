//
//  Constants.swift
//  Calculator
//
//  Created by Mustafa on 8/5/20.
//  Copyright © 2020 Mustafa Nafie. All rights reserved.
//

import UIKit

struct Constants {
	
	static let fontSize: CGFloat = 17
	static let resultfontSize: CGFloat = 30
	
	static let defaultMargin: CGFloat = 20
	static let cellPadding: CGFloat = 5
	
	static let cellIdentifier = "cellIdentifier"
	
	enum Operators: String {
		case addition = "+"
		case subtraction = "-"
		case multiplication = "*"
		case division = "/"
		case equal = "="
		case undo = "Undo"
		case redo = "Redo"
		case none = ""
	}
	
	enum Strings: String {
		case result = "Result"
		case secondOperandPlaceholder = "Please Enter the Second Operand"
	}
	
}
