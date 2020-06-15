//
//  MainScreeenVC.swift
//  InternshipTask
//
//  Created by Mihir Luthra on 15/06/20.
//  Copyright © 2020 Mihir Luthra. All rights reserved.
//

import UIKit

class MainScreeenVC: UIViewController {

	let address = """
	2nd Floor, Hno 12, Road no 37, \
	Back Side of Mgs Hospital , West Punjabi Bagh, \
	Pubjabi Bagh, Delhi, 110026, India
	"""
	
	@IBOutlet weak var addressLabel: UILabel!
	@IBOutlet weak var reportIssueButton: CircularEdgedButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		addressLabel.text = address
		reportIssueButton.isEnabled = false
    }
}
