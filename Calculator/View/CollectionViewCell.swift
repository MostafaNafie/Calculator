//
//  CollectionViewCell.swift
//  Calculator
//
//  Created by Mustafa on 7/5/20.
//  Copyright © 2020 Mustafa Nafie. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
		
	let resultLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.font = .systemFont(ofSize: Constants.fontSize)
		label.textAlignment = .center
		label.textColor = .white
		label.backgroundColor = .black
		return label
	}()
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
		setupLayout()
	}
	
}

extension CollectionViewCell {
	
	private func setupUI() {
		backgroundColor = .white
		addSubview(resultLabel)
	}
	
	private func setupLayout() {
		// Result Label
		NSLayoutConstraint.activate([
			resultLabel.topAnchor.constraint(equalTo: topAnchor, constant: Constants.cellPadding),
			resultLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.cellPadding),
			resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.cellPadding),
			resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.cellPadding)
		])
	}
	
}
