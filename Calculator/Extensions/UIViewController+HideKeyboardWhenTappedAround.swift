//
//  UIViewController+HideKeyboardWhenTappedAround.swift
//  Calculator
//
//  Created by Mustafa on 9/5/20.
//  Copyright © 2020 Mustafa Nafie. All rights reserved.
//

import UIKit

extension UIViewController {
	func hideKeyboardWhenTappedAround() {
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
	}
	
	@objc func dismissKeyboard() {
		view.endEditing(true)
	}
}
