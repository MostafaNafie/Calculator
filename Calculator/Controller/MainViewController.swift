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

	override func viewDidLoad() {
		super.viewDidLoad()

		mainView.setupView()
	}

}

