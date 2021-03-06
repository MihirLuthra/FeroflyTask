//
//  PinkGradient.swift
//  InternshipTask
//
//  Created by Mihir Luthra on 15/06/20.
//  Copyright © 2020 Mihir Luthra. All rights reserved.
//

import UIKit

extension UIView {
	
	func setGradientBackground(colors : [CGColor]) {
		
		self.backgroundColor = .none
		
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = bounds
		gradientLayer.colors = colors
		gradientLayer.locations = [0.0, 1.0]
		gradientLayer.startPoint = CGPoint(x: 1.0, y: 0)
		gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
		
		layer.insertSublayer(gradientLayer, at: 0)
	}
	
	func removeGradientBackground() {
		guard
			let idx = layer.sublayers?.firstIndex(where: { $0 is CAGradientLayer })
			else { return }
		
		layer.sublayers?.remove(at: idx)
	}
}
