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
		label.text = "+5"
		label.font = .systemFont(ofSize: 17)
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
			resultLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
			resultLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
			resultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
			resultLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5)
		])
	}
	
}
