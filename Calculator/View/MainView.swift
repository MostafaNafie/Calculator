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
	
}

// MARK: - Helper functions

extension MainView {
	
	func setupView() {
		setupUI()
		setupLayout()
	}
	
	private func setupUI() {
		addSubview(resultLabel)
	}
	
	private func setupLayout() {
		// Result Label
		NSLayoutConstraint.activate([
			resultLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 20),
			resultLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
		])
	}
	
}

