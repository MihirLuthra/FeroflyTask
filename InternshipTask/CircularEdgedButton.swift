//
//  CircularEdgedButton.swift
//  InternshipTask
//
//  Created by Mihir Luthra on 15/06/20.
//  Copyright © 2020 Mihir Luthra. All rights reserved.
//

import UIKit

class CircularEdgedButton: UIButton {
	
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setButton()
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setButton()
	}
	
	
	private func setButton() {
		
		// set shadow
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSize(width: 0.0, height: 10.0)
		layer.shadowRadius = 8
		layer.shadowOpacity = 0.25
		clipsToBounds = true
		layer.masksToBounds = false
		
		setTitleColor(.white, for: .normal)
		
		backgroundColor = UIColor(red: 245/255, green: 0/255, blue: 38/255, alpha: 1)
		layer.cornerRadius = 20
	}
}
