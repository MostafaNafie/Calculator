//
//  UIView+SetAutoLayout.swift
//  Calculator
//
//  Created by Mustafa on 9/5/20.
//  Copyright © 2020 Mustafa Nafie. All rights reserved.
//

import UIKit

extension UIView {
	func setSubviewForAutoLayout(_ subview: UIView) {
		subview.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(subview)
	}
	
	func setSubviewsForAutoLayout(_ subviews: [UIView]) {
		subviews.forEach(self.setSubviewForAutoLayout)
	}
}
