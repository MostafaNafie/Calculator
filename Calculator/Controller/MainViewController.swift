//
//  MainViewController.swift
//  Calculator
//
//  Created by Mustafa on 7/5/20.
//  Copyright © 2020 Mustafa Nafie. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

	private lazy var mainView = view as! MainView
	
	private var firstOperand = 0
	private var secondOperand: Int?
	private var operation: String?

	override func loadView() {
		view = MainView(frame: CGRect())
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		setupCollectionView()
		attachTargetsToButtons()
	}

}

// MARK: - Actions

extension MainViewController {
	
	@objc func operationButtonTapped(sender: UIButton) {
		operation = sender.titleLabel?.text
		print("\(operation!) Button Tapped")
	}
	
}

// MARK: - CollectionView DataSource

extension MainViewController: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return 5
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellIdentifier", for: indexPath)
		return cell
	}
	
}

// MARK: - CollectionView Delegate

extension MainViewController: UICollectionViewDelegate {
	
	
	
}

// MARK: - Helper functions

extension MainViewController {
	
	private func setupCollectionView() {
		mainView.historyCollectionView.delegate = self
		mainView.historyCollectionView.dataSource = self
		mainView.historyCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "cellIdentifier")
	}
	
	private func attachTargetsToButtons() {
		mainView.additionButton.addTarget(self, action: #selector(operationButtonTapped(sender:)), for: .touchUpInside)
		mainView.substractionButton.addTarget(self, action: #selector(operationButtonTapped(sender:)), for: .touchUpInside)
		mainView.multiplicationButton.addTarget(self, action: #selector(operationButtonTapped(sender:)), for: .touchUpInside)
		mainView.divisionButton.addTarget(self, action: #selector(operationButtonTapped(sender:)), for: .touchUpInside)
	}
	
}

