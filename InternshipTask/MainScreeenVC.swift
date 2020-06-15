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
	@IBOutlet weak var reportIssue: CircularEdgedButton!
	@IBOutlet weak var trackOrder: UIButton!
	
	override func viewDidLoad() {
        super.viewDidLoad()
		addressLabel.text = address
		reportIssue.isEnabled = false
		
		trackOrder.imageView?.contentMode = .scaleAspectFit
		trackOrder.imageEdgeInsets = UIEdgeInsets(top: (trackOrder.imageView?.frame.minY)! + 25, left: (trackOrder.imageView?.frame.minX)! - 10, bottom: 30, right: 5)
    }
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "toMapVC" {
			let destinationVC = segue.destination as! MapVC
			destinationVC.searchString = address
			
		}
	}
}
